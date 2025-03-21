/*
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package openstacktasks

import (
	"fmt"

	v2pools "github.com/gophercloud/gophercloud/v2/openstack/loadbalancer/v2/pools"
	"k8s.io/klog/v2"
	"k8s.io/kops/upup/pkg/fi"
	"k8s.io/kops/upup/pkg/fi/cloudup/openstack"
)

// +kops:fitask
type LBPool struct {
	ID           *string
	Name         *string
	Lifecycle    fi.Lifecycle
	Loadbalancer *LB
}

// GetDependencies returns the dependencies of the Instance task
func (e *LBPool) GetDependencies(tasks map[string]fi.CloudupTask) []fi.CloudupTask {
	var deps []fi.CloudupTask
	for _, task := range tasks {
		if _, ok := task.(*LB); ok {
			deps = append(deps, task)
		}
	}
	return deps
}

var _ fi.CompareWithID = &LBPool{}

func (s *LBPool) CompareWithID() *string {
	return s.ID
}

func NewLBPoolTaskFromCloud(cloud openstack.OpenstackCloud, lifecycle fi.Lifecycle, pool *v2pools.Pool, find *LBPool) (*LBPool, error) {
	if len(pool.Loadbalancers) > 1 {
		return nil, fmt.Errorf("Openstack cloud pools with multiple loadbalancers not yet supported!")
	}

	a := &LBPool{
		ID:        fi.PtrTo(pool.ID),
		Name:      fi.PtrTo(pool.Name),
		Lifecycle: lifecycle,
	}
	if len(pool.Loadbalancers) == 1 {
		lbID := pool.Loadbalancers[0]
		lb, err := cloud.GetLB(lbID.ID)
		if err != nil {
			return nil, fmt.Errorf("NewLBPoolTaskFromCloud: Failed to get lb with id %s: %v", lbID.ID, err)
		}
		loadbalancerTask, err := NewLBTaskFromCloud(cloud, lifecycle, lb, nil)
		if err != nil {
			return nil, err
		}
		a.Loadbalancer = loadbalancerTask
	}
	if find != nil {
		// Update all search terms
		find.ID = a.ID
		find.Name = a.Name
	}
	return a, nil
}

func (p *LBPool) Find(context *fi.CloudupContext) (*LBPool, error) {
	if p.Name == nil && p.ID == nil {
		return nil, nil
	}

	cloud := context.T.Cloud.(openstack.OpenstackCloud)
	poolList, err := cloud.ListPools(v2pools.ListOpts{
		ID:   fi.ValueOf(p.ID),
		Name: fi.ValueOf(p.Name),
	})
	if err != nil {
		return nil, fmt.Errorf("Failed to list pools: %v", err)
	}
	if len(poolList) == 0 {
		return nil, nil
	}
	if len(poolList) > 1 {
		return nil, fmt.Errorf("Multiple pools found for name %s", fi.ValueOf(p.Name))
	}

	return NewLBPoolTaskFromCloud(cloud, p.Lifecycle, &poolList[0], p)
}

func (s *LBPool) Run(context *fi.CloudupContext) error {
	return fi.CloudupDefaultDeltaRunMethod(s, context)
}

func (_ *LBPool) CheckChanges(a, e, changes *LBPool) error {
	if a == nil {
		if e.Name == nil {
			return fi.RequiredField("Name")
		}
	} else {
		if changes.ID != nil {
			return fi.CannotChangeField("ID")
		}
		if changes.Name != nil {
			return fi.CannotChangeField("Name")
		}
	}
	return nil
}

func (_ *LBPool) RenderOpenstack(t *openstack.OpenstackAPITarget, a, e, changes *LBPool) error {
	if a == nil {

		// wait that lb is in ACTIVE state
		provisioningStatus, err := waitLoadbalancerActiveProvisioningStatus(t.Cloud.LoadBalancerClient(), fi.ValueOf(e.Loadbalancer.ID))
		if err != nil {
			return fmt.Errorf("failed to loadbalancer ACTIVE provisioning status %v: %v", provisioningStatus, err)
		}

		LbMethod := v2pools.LBMethodRoundRobin
		if fi.ValueOf(e.Loadbalancer.Provider) == "ovn" {
			LbMethod = v2pools.LBMethodSourceIpPort
		}
		poolopts := v2pools.CreateOpts{
			Name:           fi.ValueOf(e.Name),
			LBMethod:       LbMethod,
			Protocol:       v2pools.ProtocolTCP,
			LoadbalancerID: fi.ValueOf(e.Loadbalancer.ID),
		}
		pool, err := t.Cloud.CreatePool(poolopts)
		if err != nil {
			return fmt.Errorf("error creating LB pool: %v", err)
		}
		e.ID = fi.PtrTo(pool.ID)

		return nil
	}

	klog.V(2).Infof("Openstack task LB::RenderOpenstack did nothing")
	return nil
}

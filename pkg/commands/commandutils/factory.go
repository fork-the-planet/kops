/*
Copyright 2021 The Kubernetes Authors.

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

package commandutils

import (
	"context"

	"k8s.io/client-go/rest"

	"k8s.io/kops/pkg/apis/kops"
	"k8s.io/kops/pkg/client/simple"
	"k8s.io/kops/pkg/kubeconfig"
	"k8s.io/kops/util/pkg/vfs"
)

type Factory interface {
	KopsClient() (simple.Clientset, error)
	VFSContext() *vfs.VFSContext
	RESTConfig(ctx context.Context, cluster *kops.Cluster, options kubeconfig.CreateKubecfgOptions) (*rest.Config, error)
}

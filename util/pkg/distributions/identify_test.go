/*
Copyright 2020 The Kubernetes Authors.

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

package distributions

import (
	"fmt"
	"path"
	"reflect"
	"testing"
)

func TestFindDistribution(t *testing.T) {
	tests := []struct {
		rootfs   string
		err      error
		expected Distribution
	}{
		{
			rootfs:   "amazonlinux2",
			err:      nil,
			expected: DistributionAmazonLinux2,
		},
		{
			rootfs:   "amazonlinux2023",
			err:      nil,
			expected: DistributionAmazonLinux2023,
		},
		{
			rootfs:   "centos7",
			err:      fmt.Errorf("unsupported distro %q", "centos-7"),
			expected: Distribution{},
		},
		{
			rootfs:   "centos8",
			err:      fmt.Errorf("unsupported distro %q", "centos-8"),
			expected: Distribution{},
		},
		{
			rootfs:   "coreos",
			err:      fmt.Errorf("unsupported distro %q", "coreos-2247.7.0"),
			expected: Distribution{},
		},
		{
			rootfs:   "containeros",
			err:      nil,
			expected: DistributionContainerOS,
		},
		{
			rootfs:   "debian8",
			err:      fmt.Errorf("unsupported distro %q", "debian-8"),
			expected: Distribution{},
		},
		{
			rootfs:   "debian9",
			err:      fmt.Errorf("unsupported distro %q", "debian-9"),
			expected: Distribution{},
		},
		{
			rootfs:   "debian10",
			err:      nil,
			expected: DistributionDebian10,
		},
		{
			rootfs:   "debian11",
			err:      nil,
			expected: DistributionDebian11,
		},
		{
			rootfs:   "debian12",
			err:      nil,
			expected: DistributionDebian12,
		},
		{
			rootfs:   "flatcar",
			err:      nil,
			expected: DistributionFlatcar,
		},
		{
			rootfs:   "rhel7",
			err:      fmt.Errorf("unsupported distro %q", "rhel-7.8"),
			expected: Distribution{},
		},
		{
			rootfs:   "rhel8",
			err:      nil,
			expected: DistributionRhel8,
		},
		{
			rootfs:   "rhel9",
			err:      nil,
			expected: DistributionRhel9,
		},
		{
			rootfs:   "rocky8",
			err:      nil,
			expected: DistributionRocky8,
		},
		{
			rootfs:   "rocky9",
			err:      nil,
			expected: DistributionRocky9,
		},
		{
			rootfs:   "ubuntu1604",
			err:      fmt.Errorf("unsupported distro %q", "ubuntu-16.04"),
			expected: Distribution{},
		},
		{
			rootfs:   "ubuntu2004",
			err:      nil,
			expected: DistributionUbuntu2004,
		},
		{
			rootfs:   "ubuntu2204",
			err:      nil,
			expected: DistributionUbuntu2204,
		},
		{
			rootfs:   "ubuntu2404",
			err:      nil,
			expected: DistributionUbuntu2404,
		},
		{
			rootfs:   "notfound",
			err:      fmt.Errorf("reading /etc/os-release: open tests/notfound/etc/os-release: no such file or directory"),
			expected: Distribution{},
		},
	}

	for _, test := range tests {
		actual, err := FindDistribution(path.Join("tests", test.rootfs))
		if !reflect.DeepEqual(err, test.err) {
			t.Errorf("unexpected error, actual=\"%v\", expected=\"%v\"", err, test.err)
			continue
		}
		if actual != test.expected {
			t.Errorf("unexpected distribution, actual=%v, expected=%v", actual, test.expected)
		}
	}
}

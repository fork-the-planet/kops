/*
Copyright 2019 The Kubernetes Authors.

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

package kubeconfig

import (
	"fmt"

	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	clientcmdapi "k8s.io/client-go/tools/clientcmd/api"
	"k8s.io/klog/v2"
)

// KubeconfigBuilder builds a kubecfg file
// This logic previously lives in the bash scripts (create-kubeconfig in cluster/common.sh)
type KubeconfigBuilder struct {
	Server        string
	TLSServerName string

	Context   string
	Namespace string

	User         string
	KubeUser     string
	KubePassword string

	CACerts    []byte
	ClientCert []byte
	ClientKey  []byte

	AuthenticationExec []string
}

// Create new KubeconfigBuilder
func NewKubeconfigBuilder() *KubeconfigBuilder {
	return &KubeconfigBuilder{}
}

func (b *KubeconfigBuilder) DeleteKubeConfig(configAccess clientcmd.ConfigAccess) error {
	config, err := configAccess.GetStartingConfig()
	if err != nil {
		return fmt.Errorf("error loading kubeconfig: %v", err)
	}

	if config == nil || clientcmdapi.IsConfigEmpty(config) {
		klog.V(2).Info("kubeconfig is empty")
		return nil
	}

	delete(config.Clusters, b.Context)
	delete(config.AuthInfos, b.Context)
	delete(config.AuthInfos, fmt.Sprintf("%s-basic-auth", b.Context))
	delete(config.Contexts, b.Context)

	if config.CurrentContext == b.Context {
		config.CurrentContext = ""
	}

	if err := clientcmd.ModifyConfig(configAccess, *config, false); err != nil {
		return fmt.Errorf("error writing kubeconfig: %v", err)
	}

	fmt.Printf("Deleted kubectl config for %s\n", b.Context)
	return nil
}

// Write out a new kubeconfig
func (b *KubeconfigBuilder) WriteKubecfg(configAccess clientcmd.ConfigAccess) error {
	config, err := configAccess.GetStartingConfig()
	if err != nil {
		return fmt.Errorf("error reading kubeconfig: %v", err)
	}

	if config == nil {
		config = &clientcmdapi.Config{}
	}

	{
		cluster := config.Clusters[b.Context]
		if cluster == nil {
			cluster = clientcmdapi.NewCluster()
		}
		cluster.Server = b.Server
		cluster.TLSServerName = b.TLSServerName
		cluster.CertificateAuthorityData = b.CACerts

		if config.Clusters == nil {
			config.Clusters = make(map[string]*clientcmdapi.Cluster)
		}
		config.Clusters[b.Context] = cluster
	}

	// We avoid changing the user unless we're actually writing something
	// Issue #11537
	haveUserInfo := false

	// If the user has the same name as the context, it is the admin user
	if b.User == b.Context {
		authInfo := config.AuthInfos[b.Context]
		if authInfo == nil {
			authInfo = clientcmdapi.NewAuthInfo()
		}

		// If we are using the auth plugin, we want to clear the password & client-key,
		// otherwise the auth plugin won't be used

		usingAuthPlugin := len(b.AuthenticationExec) != 0
		if (b.KubeUser != "" && b.KubePassword != "") || usingAuthPlugin {
			authInfo.Username = b.KubeUser
			authInfo.Password = b.KubePassword

			haveUserInfo = true
		}

		if (b.ClientCert != nil && b.ClientKey != nil) || usingAuthPlugin {
			authInfo.ClientCertificate = ""
			authInfo.ClientCertificateData = b.ClientCert
			authInfo.ClientKey = ""
			authInfo.ClientKeyData = b.ClientKey

			haveUserInfo = true
		}

		if usingAuthPlugin {
			authInfo.Exec = &clientcmdapi.ExecConfig{
				APIVersion: "client.authentication.k8s.io/v1beta1",
				Command:    b.AuthenticationExec[0],
				Args:       b.AuthenticationExec[1:],
			}

			haveUserInfo = true
		}

		if haveUserInfo {
			if config.AuthInfos == nil {
				config.AuthInfos = make(map[string]*clientcmdapi.AuthInfo)
			}
			config.AuthInfos[b.Context] = authInfo
		}
	} else if b.User != "" {
		if config.AuthInfos[b.User] == nil {
			return fmt.Errorf("could not find user %q", b.User)
		}
		haveUserInfo = true
	}

	// If we have a bearer token, also create a credential entry with basic auth
	// so that it is easy to discover the basic auth password for your cluster
	// to use in a web browser.
	if b.KubeUser != "" && b.KubePassword != "" {
		name := b.Context + "-basic-auth"
		authInfo := config.AuthInfos[name]
		if authInfo == nil {
			authInfo = clientcmdapi.NewAuthInfo()
		}

		authInfo.Username = b.KubeUser
		authInfo.Password = b.KubePassword

		if config.AuthInfos == nil {
			config.AuthInfos = make(map[string]*clientcmdapi.AuthInfo)
		}
		config.AuthInfos[name] = authInfo
	}

	{
		context := config.Contexts[b.Context]
		if context == nil {
			context = clientcmdapi.NewContext()
		}

		context.Cluster = b.Context
		if haveUserInfo {
			if b.User != "" {
				context.AuthInfo = b.User
			}
		}

		if b.Namespace != "" {
			context.Namespace = b.Namespace
		}

		if config.Contexts == nil {
			config.Contexts = make(map[string]*clientcmdapi.Context)
		}
		config.Contexts[b.Context] = context
	}

	config.CurrentContext = b.Context

	if err := clientcmd.ModifyConfig(configAccess, *config, true); err != nil {
		return err
	}

	fmt.Printf("kOps has set your kubectl context to %s\n", b.Context)
	return nil
}

func (b *KubeconfigBuilder) ToRESTConfig() (*rest.Config, error) {
	restConfig := &rest.Config{}

	restConfig.Host = b.Server
	restConfig.TLSClientConfig.CAData = b.CACerts
	restConfig.TLSClientConfig.ServerName = b.TLSServerName

	usingAuthPlugin := len(b.AuthenticationExec) != 0
	if usingAuthPlugin {
		return nil, fmt.Errorf("auth plugin not yet supported by ToRESTConfig")
	}

	restConfig.CertData = b.ClientCert
	restConfig.KeyData = b.ClientKey

	return restConfig, nil
}

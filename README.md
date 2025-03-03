<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/twplatformlabs/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-control-plane-extensions</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/psk-aws-control-plane-extensions"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

### Current Extensions

- istio
- cert-manager
- external-dns


#### istio

- Deploys Istio using `istioctl install` with parameters file
- - json logging by default
- - ingressgateway enabled
- external-dns manages route53 automation, watching:
- - service
- - ingress
- - istio-gateway
- - istio-virtualservice
- Deploys cert-manager with letsencrypt integration for automated ingressgateway certificates

### gateways

Default domain gateways in production cluster:  

| gateway                       | urls                      |
|-------------------------------|---------------------------|
| twplatformlabs.org-gateway    | (*.)twplatformlabs.org    |
| twplatformlabs.link-gateway   | (*.)twplatformlabs.link   |


Cluster specific gateways:

| gateway                                             | urls                                            |  cluster                |
|-----------------------------------------------------|-------------------------------------------------|-------------------------|
| sbx-i01-aws-us-east-1.twplatformlabs.org-gateway    | (*.)sbx-i01-aws-us-east-1.twplatformlabs.org    | sbx-i01-aws-us-east-1   |
| sbx-i01-aws-us-east-1.twplatformlabs.link-gateway   | (*.)sbx-i01-aws-us-east-1.twplatformlabs.link   | sbx-i01-aws-us-east-1   |
| prod-i01-aws-us-east-1.twplatformlabs.org-gateway   | (*.)prod-i01-aws-us-east-1.twplatformlabs.org   | prod-i01-aws-us-east-2  |
| prod-i01-aws-us-east-1.twplatformlabs.link-gateway  | (*.)prod-i01-aws-us-east-1.twplatformlabs.link  | prod-i01-aws-us-east-2  |

Ingress domains should be considered a organizational _Product_ decision. In other words, Decide on the top-level subdomains that reflect the product strategy you have in mind for api product domains. For many companies this can be as simple as https://api.example.com. Custom API are to be referenced with the left-of-domain path definition (api.example.com/v1/profiles...).  

Where there are a limited set or unlikley to change ingress patterns, the configuration could be included within the extensions pipeline. In many enterprise situations there will be a need for a more complex, or even customer-managed, experience around ingress domains and therefore a dedicated platform API would need to be created to manage this feature. But even in that situation, there will probably be a brief period where alpha-users of the platform need to be onboarded with ingress capabilities. See the psk-platform-simple-teams-and-ns pipeline for an example of a lightweight, interim method to manage the basic 'customer' configuration within a cluster while the API driven solution is being created.  

**Default namespace**  

A `default-mtls` namespace is deployed to each cluster for validate and testing of istio configurations.

### upgrades

Create a new revision config in the istio-configuration folder. Update the version in the install.json files and deploy. Note: this is presently an in-place upgrade that may result in momentary service interruption.

**validate basic mesh functionality**  

Deploys an instance of httpbin to the default-mtls namespace and defines a virtual service on the default cluster gateway at httpbin.__cluster__ twplatformlabs.org domain. A successful test confirms the healthy functionality of the following:  
- the ingressgateway service successfully provisioned an ELB
- gateways were defined for the domains managed by the cluster
- certificates were successfully requested from Let'sEncrypt and are attached to the gateways
- envoy sidecars are successfully injected into managed namespaces
- istiod and the istio mutatingwebhook are successfully proxying traffic via envoy
- tls traffic successfully reaches the httpbin test application

## Deprecated

| gateway                                       | urls                                     |  cluster                |
|-----------------------------------------------|------------------------------------------|-------------------------|
| twdps.digital-gateway                         | (*.)twdps.digital                        | sbx-i01-aws-us-east-1   |
| twdps.io-gateway                              | (*.)twdps.io                             | prod-i01-aws-us-east-1  |
| sbx-i01-aws-us-east-1.twdps.digital-gateway   | (*.)sbx-i01-aws-us-east-1.twdps.digital  | sbx-i01-aws-us-east-1   |
| sbx-i01-aws-us-east-1.twdps.io-gateway        | (*.)sbx-i01-aws-us-east-1.twdps.io       | sbx-i01-aws-us-east-1   |
| prod-i01-aws-us-east-1.twdps.digital-gateway  | (*.)prod-i01-aws-us-east-1.twdps.digital | prod-i01-aws-us-east-1  |
| prod-i01-aws-us-east-1.twdps.io-gateway       | (*.)prod-i01-aws-us-east-1.twdps.io      | prod-i01-aws-us-east-1  |

Above domains will be removed.  
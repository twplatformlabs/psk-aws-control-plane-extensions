<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-aws-control-plane-extensions</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-aws-control-plane-extensions"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

### Current Extensions

- istio
- cert-manager
- external-dns

- Deploys Istio using `istioctl install` with parameters file
- - Uses canary upgrade deployment method. If istio has not yet been deployed to the cluster, it will do a default/prod revision install of the same version.
- - distroless images
- - json logging by default
- - tracing enabled
- - ingressgateway enabled
- Deploys external-dns for route53 automation
- Deploys cert-manager with letsencrypt integration for automated ingress certificates

### gateways

Cert-manager is configured to use Let'sEncrypt for tls.  

Default environment gateways:  

| gateway                                 | urls                                |  cluster                |
|-----------------------------------------|-------------------------------------|-------------------------|
| preview.twdps.digital-gateway           | (*.)preview.twdps.digital           | sbx-i01-aws-us-east-1   |
| preview.twdps.io-gateway                | (*.)preview.twdps.io                | sbx-i01-aws-us-east-1   |
| dev.twdps.digital-gateway               | (*.)dev.twdps.digital               | prod-i01-aws-us-east-1  |
| dev.twdps.io-gateway                    | (*.)dev.twdps.io                    | prod-i01-aws-us-east-1  |
| qa.twdps.digital-gateway                | (*.)qa.twdps.digital                | prod-i01-aws-us-east-1  |
| qa.twdps.io-gateway                     | (*.)qa.twdps.io                     | prod-i01-aws-us-east-1  |
| prod.twdps.digital-gateway              | (*.)prod.twdps.digital              | prod-i01-aws-us-east-1  |
| prod.twdps.io-gateway                   | (*.)prod.twdps.io                   | prod-i01-aws-us-east-1  |
| twdps.io-gateway                        | (*.)twdps.io                        | prod-i01-aws-us-east-1  |
| twdps.digital-gateway                   | (*.)twdps.digital                   | sbx-i01-aws-us-east-1   |

Cluster specific gateways:

| gateway                                       | urls                                     |  cluster                |
|-----------------------------------------------|------------------------------------------|-------------------------|
| sbx-i01-aws-us-east-1.twdps.digital-gateway   | (*.)sbx-i01-aws-us-east-1.twdps.digital  | sbx-i01-aws-us-east-1   |
| sbx-i01-aws-us-east-1.twdps.io-gateway        | (*.)sbx-i01-aws-us-east-1.twdps.io       | sbx-i01-aws-us-east-1   |
| prod-i01-aws-us-east-1.twdps.digital-gateway  | (*.)prod-i01-aws-us-east-1.twdps.digital | prod-i01-aws-us-east-1  |
| prod-i01-aws-us-east-1.twdps.io-gateway       | (*.)prod-i01-aws-us-east-1.twdps.io      | prod-i01-aws-us-east-1  |

A typical external->internal routing patterns for domains would be:

api.twdps.io      >  api-gateway  >  api.prod.preview.twdps.io

Note: the pending teams.api release will shift management of standard environment gateways to the api rather than through an infra pipeline.

**Default namespace**  

A `default-mtls` namespace is deployed to each cluster for validate and testing of istio configurations.

### upgrades

Create a new revision config in the istio-configuration folder. Update the version in the install.json files and deploy. Note: this is presently an in-place upgrade that results in momentary service interruption.

**validate basic mesh functionality**  

Deploys an instance of httpbin to the default-mtls namespace and defines a virtual service on the default cluster gateway at httpbin.__cluster__ twdps.io domain. A successful test confirms the healthy functionality of the following:  
- the ingressgateway service successfully provisioned an ELB
- gateways were defined for the domains managed by the cluster
- certificates were successfully requested from Let'sEncrypt and are attached to the gateways
- envoy sidecars are successfully injected into managed namespaces
- istiod and the istio mutatingwebhook are successfully proxying traffic via envoy
- tls traffic successfully reaches the httpbin test application

#### TODO:

Add services:  
- crossplane
- k6

other:  
- The external-dns deployment only supports a pre-defined list of env gateways. When the teams-api assumes the role of gateway management then the configuration deployed in this pipeline can reduce to only the cluster-name specific subdomain.
- convert istio install/upgrade to revision-based canary method.
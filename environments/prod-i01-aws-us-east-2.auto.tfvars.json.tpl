{
  "aws_account_id": "{{ op://platform/aws-production/aws-account-id }}",
  "aws_assume_role": "PSKRoles/PSKControlPlaneBaseRole",
  "aws_region": "us-east-2",
  "cluster_name": "prod-i01-aws-us-east-2",
  "cert_manager_chart_version": "1.17.1",
  "external_dns_chart_version": "1.16.0",
  "istio_version": "1.24.4",

  "cluster_domains": [
    "twplatformlabs.org",
    "prod-i01-aws-us-east-2.twplatformlabs.org",
    "twplatformlabs.link",
    "prod-i01-aws-us-east-2.twplatformlabs.link",
    "twdps.io",
    "prod-i01-aws-us-east-2.twdps.digital",
    "prod-i01-aws-us-east-2.twdps.io"
  ],
  "issuerEndpoint": "https://acme-v02.api.letsencrypt.org/directory",
  "issuerEmail": "twplatformlabs@gmail.com"
}
{
  "aws_account_id": "{{ op://empc-lab/aws-dps-1/aws-account-id }}",
  "aws_assume_role": "PSKRoles/PSKControlPlaneBaseRole",
  "aws_region": "us-east-2",
  "cluster_name": "prod-i01-aws-us-east-2",
  "cert_manager_chart_version": "1.15.4",
  "external_dns_chart_version": "1.14.4",
  "istio_version": "1.22.2",

  "cluster_domains": [
    "twdps.io",
    "prod-i01-aws-us-east-2.twdps.digital",
    "prod-i01-aws-us-east-2.twdps.io"
  ],
  "issuerEndpoint": "https://acme-v02.api.letsencrypt.org/directory",
  "issuerEmail": "twdps.io@gmail.com"
}
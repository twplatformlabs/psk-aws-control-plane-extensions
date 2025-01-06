{
  "aws_account_id": "{{ op://empc-lab/aws-dps-2/aws-account-id }}",
  "aws_assume_role": "PSKRoles/PSKControlPlaneBaseRole",
  "aws_region": "us-east-1",
  "cluster_name": "sbx-i01-aws-us-east-1",
  "cert_manager_chart_version": "1.15.4",
  "external_dns_chart_version": "1.15.1",
  "istio_version": "1.24.2",

  "cluster_domains": [
    "twdps.digital",
    "sbx-i01-aws-us-east-1.twdps.digital",
    "sbx-i01-aws-us-east-1.twdps.io"
  ],
  "issuerEndpoint": "https://acme-v02.api.letsencrypt.org/directory",
  "issuerEmail": "twdps.io@gmail.com"
}
{
  "aws_account_id": "{{ op://platform/aws-sandbox/aws-account-id }}",
  "aws_assume_role": "PSKRoles/PSKControlPlaneBaseRole",
  "aws_region": "us-east-1",
  "cluster_name": "sbx-i01-aws-us-east-1",
  "cert_manager_chart_version": "1.17.1",
  "external_dns_chart_version": "1.16.0",
  "istio_version": "1.25.1",

  "cluster_domains": [
    "sbx-i01-aws-us-east-1.twplatformlabs.org",
    "sbx-i01-aws-us-east-1.twplatformlabs.link"
  ],
  "issuerEndpoint": "https://acme-v02.api.letsencrypt.org/directory",
  "issuerEmail": "twplatformlabs@gmail.com"
}
require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['WORKSPACE'] + '.auto.tfvars.json'))

describe iam_role(tfvars['cluster_name'] + '-cert-manager-sa') do
  it { should exist }
end

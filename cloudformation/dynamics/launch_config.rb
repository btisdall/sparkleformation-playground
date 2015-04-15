require 'base64'

SparkleFormation.dynamic(:launch_config) do |_name, _config = {}|

  # Shamelessly copied from https://github.com/gswallow/cfn-templates/
  # See http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-launchconfig.html

  userdata_header = <<EOF
#!/usr/bin/env bash
set -e -x
EOF

  facts_header = <<EOF
# propagate facts to instance for use by Puppet
# Note that some values are not known until stack creation is in progress
EOF

  userdata_body = <<EOF
exec > /var/log/bootstrap.log 2>&1
apt-get update
apt-get -y install python-pip
pip install awscli
aws s3 cp s3://babel-instance-bootstrap/bin/bootstrap_provisioning.sh /root/bootstrap_provisioning.sh
bash /root/bootstrap_provisioning.sh
EOF

  mappings.region_to_ami_map do
    _set('us-east-1'._no_hump, :ami => 'ami-eab68a82')
    _set('us-west-1'._no_hump, :ami => 'ami-951945d0')
    _set('us-west-2'._no_hump, :ami => 'ami-ff6182bb')
    _set('eu-west-1'._no_hump, :ami => 'ami-4d5b707d')
  end

  facts = { 'babel_role' => _name, 'babel_environment' => ref!(:environment) }.merge(_config[:facts] || {} )

  resources("#{_name}_launch_config".to_sym) do
    type 'AWS::AutoScaling::LaunchConfiguration'
    properties do
      image_id _config[:image_id] || _cf_map(:region_to_ami_map, 'AWS::Region', 'ami'._no_hump)
      instance_type _config[:instance_type] || ref!(:default_instance_type)
      associate_public_ip_address _config[:public_ips] || false
      iam_instance_profile _config[:iam_instance_profile] || 'babel-instance-bootstrap'
      key_name _config[:key_name] || ref!(:key_name)
      security_groups array!( *_config[:security_groups] )
      user_data base64!(join!(
        userdata_header,
        facts_header,
        facts.map { |k,v| join!('export', ' ', 'BABEL_FACT_', k, '=', v, "\n") },
        userdata_body
      ))
    end
  end
end

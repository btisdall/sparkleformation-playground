SparkleFormation.new('simple_app_stack').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  parameters do
    key_name do
      description 'Name of an existing EC2 KeyPair to enable SSH access to the instance'
      type 'String'
      default 'bentis-no-pp'
    end
    environment do
      description 'Environment eg "test", "production"'
      type 'String'
    end
    role do
      description 'Role eg "web", "cache"'
      type 'String'
    end
  end

  dynamic!(:web_and_api_launch_config, 'bentis_test', :public_ips => true, :security_groups => ['sg-efd5ac8b'])

  outputs do
    instance_id do
      description 'Name of the lauch configuration'
      value _cf_ref(:launch_config)
    end
  end
end

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
    instance_type do
      description 'Instance type eg "m3.large"'
      type 'String'
    end
  end

  dynamic!( :babel_general_launch_config, :web_launch_config, :instance_type => ref!(:instance_type), :security_groups => ['sg-efd5ac8b'])
  dynamic!( :babel_general_asg, :web_asg, :launch_configuration_name => ref!(:web_launch_config))

  outputs do
    instance_id do
      description 'Name of the lauch configuration'
      value _cf_ref(:web_launch_config)
    end
  end
end

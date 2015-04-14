SparkleFormation.new('simple_app_stack').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  dynamic!( :babel_general_launch_config, :web_launch_config, :instance_type => ref!(:instance_type), :security_groups => ['sg-efd5ac8b'])
  dynamic!( :babel_general_asg, :web_asg, :launch_configuration_name => ref!(:web_launch_config))

  outputs do
    instance_id do
      description 'Name of the lauch configuration'
      value _cf_ref(:web_launch_config)
    end
  end
end

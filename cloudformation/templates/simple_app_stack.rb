SparkleFormation.new('simple_app_stack').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  dynamic!( :launch_config, :web_launch_config, :security_groups => ['sg-efd5ac8b'])
  dynamic!( :auto_scaling_group, :web_asg, :launch_configuration_name => ref!(:web_launch_config))

  dynamic!( :launch_config, :api_launch_config, :security_groups => ['sg-efd5ac8b'])
  dynamic!( :auto_scaling_group, :api_asg, :launch_configuration_name => ref!(:api_launch_config))
end

SparkleFormation.new('simple_app_stack').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  dynamic!(
    :launch_config,
    :web_launch_config,
    :security_groups => ['sg-efd5ac8b'],
  )
  dynamic!(
    :auto_scaling_group,
    :web_asg,
    :role_tag => 'web',
    :launch_configuration_name => ref!(:web_launch_config),
    :vpc_zone_identifier => %w(subnet-1346cc4a),
  )

  dynamic!(
    :launch_config,
    :api_launch_config,
    :security_groups => ['sg-efd5ac8b'],
  )
  dynamic!(
    :auto_scaling_group,
    :api_asg,
    :role_tag => 'api',
    :launch_configuration_name => ref!(:api_launch_config),
    :vpc_zone_identifier => %w(subnet-1346cc4a),
  )
end

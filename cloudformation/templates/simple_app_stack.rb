SparkleFormation.new('simple_app_stack').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  role = 'session_cache'
  dynamic!(
    :launch_config,
    "#{role}_launch_config".to_sym,
    :security_groups => ['sg-efd5ac8b'],
    :public_ips => true,
    :role => role,
  )
  dynamic!(
    :auto_scaling_group,
    "#{role}_auto_scaling_group".to_sym,
    :launch_configuration_name => ref!("#{role}_launch_config".to_sym),
    :vpc_zone_identifier => %w(subnet-4ab00d61),
    :availability_zones => %w(us-east-1e),
    :role => role,
  )

#  dynamic!(
#    :launch_config,
#    :api_launch_config,
#    :security_groups => ['sg-efd5ac8b'],
#  )
#  dynamic!(
#    :auto_scaling_group,
#    :api_asg,
#    :role_tag => 'api',
#    :launch_configuration_name => ref!(:api_launch_config),
#    :vpc_zone_identifier => %w(subnet-4ab00d61),
#  )
end

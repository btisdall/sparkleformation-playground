SparkleFormation.new('babel_session_cache').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  role = 'session_cache'
  dynamic!(
    :launch_config,
    role,
    :security_groups => ['sg-efd5ac8b'],
    :public_ips => true,
    :facts => { 'babel_this' => ref!(:default_instance_type) },
  )
  dynamic!(
    :auto_scaling_group,
    role,
    :launch_configuration_name => ref!("#{role}_launch_config".to_sym),
    :vpc_zone_identifier => %w(subnet-4ab00d61),
    :availability_zones => %w(us-east-1e),
  )
end

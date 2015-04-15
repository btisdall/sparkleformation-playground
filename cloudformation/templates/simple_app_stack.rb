SparkleFormation.new('babel_session_cache').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  azs = %w(e).map { |x| "us-east-1#{x}" }

  role = 'session_cache'
  dynamic!(
    :launch_config,
    role,
    :security_groups => _array(ref!("#{role}_sg".to_sym)),
    :public_ips => true,
    :facts => { 'babel_this' => ref!(:default_instance_type) },
  )
  dynamic!(
    :auto_scaling_group,
    role,
    :launch_configuration_name => ref!("#{role}_launch_config".to_sym),
    :subnets => [ref!("#{role}_#{azs.first.gsub('-', '_')}_subnet".to_sym)],
    :availability_zones => %w(us-east-1e),
  )
  dynamic!(
    :vpc_security_group,
    role,
    :ingress_rules => [
      { 'cidr_ip' => '10.0.0.0/8', 'ip_protocol' => 'tcp', 'from_port' => '22', 'to_port' => '22'},
    ],
    :allow_icmp => true,
  )
  azs.each do |az|
    dynamic!(
      :subnet,
      "#{role}_#{azs.first.gsub('-', '_')}".to_sym,
      :type => :private,
      :az => az,
      :cidr_block => '10.108.20.0/24',
      # TODO: this is nasty, the subnet dynamic I nicked already does the 'ref!'
      :route_tables => [:default_route_table],
    )
  end
end

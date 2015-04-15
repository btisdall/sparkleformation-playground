SparkleFormation.new('babel_session_cache').load(:base).overrides  do
  description "Stack for babel-session-cache, a short-term data store"

  azs = %w(e).map { |x| "us-east-1#{x}" }

  role = 'session_cache'
  dynamic!(
    :launch_config,
    role,
    :security_groups => [ role + '_sg' ],
    :public_ips => true,
    :facts => { 'babel_this' => ref!(:default_instance_type) },
  )
  dynamic!(
    :auto_scaling_group,
    role,
    :launch_configuration_name => role + '_launch_config',
    :subnets => [ "#{role}_#{azs.first.gsub('-', '_')}_subnet" ],
    :availability_zones => %w(us-east-1e),
    :load_balancer_names => ['public_elb'],
  )
  dynamic!(
    :vpc_security_group,
    role,
    :ingress_rules => [
      { 'cidr_ip' => '10.0.0.0/8', 'ip_protocol' => 'tcp', 'from_port' => '22', 'to_port' => '22'},
      { 'cidr_ip' => '10.0.0.0/8', 'ip_protocol' => 'tcp', 'from_port' => '80', 'to_port' => '80'},
    ],
    :allow_icmp => true,
  )
  dynamic!(
    :vpc_security_group,
    'public_elb',
    :ingress_rules => [
      { 'cidr_ip' => '0.0.0.0/0', 'ip_protocol' => 'tcp', 'from_port' => '80', 'to_port' => '80'},
     ],
     :allow_icmp => false
  )
  azs.each do |az|
    dynamic!(
      :subnet,
      role + '_' + az.gsub('-', '_'),
      :type => :private,
      :az => az,
      :cidr_block => '10.108.20.0/24',
      :route_tables => [:default_route_table],
    )
  end
  azs.each do |az|
    dynamic!(
      :subnet,
      'elb_' + az.gsub('-', '_'),
      :type => :public,
      :az => az,
      :cidr_block => '10.108.21.0/24',
    )
  end
  dynamic!(
    :elb,
    'public',
    :listeners => [
      { :instance_port => '80', :instance_protocol => 'http', :load_balancer_port => '80', :protocol => 'http' },
    ],
    :security_groups => [:public_elb_sg],
    :subnets => ["elb_#{azs.first.gsub('-', '_')}_subnet"],
  )

end

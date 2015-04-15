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
      "#{role}_#{az.gsub('-', '_')}".to_sym,
      :type => :private,
      :az => az,
      :cidr_block => '10.108.20.0/24',
      # TODO: this is nasty, the subnet dynamic I nicked already does the 'ref!'
      :route_tables => [:default_route_table],
    )
  end
  azs.each do |az|
    dynamic!(
      :subnet,
      "elb_#{az.gsub('-', '_')}".to_sym,
      :type => :public,
      :az => az,
      :cidr_block => '10.108.21.0/24',
      # TODO: this is nasty, the subnet dynamic I nicked already does the 'ref!'
    )
  end
  dynamic!(
    :elb,
    'public',
    :listeners => [
      { :instance_port => '80', :instance_protocol => 'http', :load_balancer_port => '80', :protocol => 'http' },
    ],
    :security_groups => [:public_elb_sg],
    :subnets => ["elb_#{azs.first.gsub('-', '_')}_subnet".to_sym],
  )

end

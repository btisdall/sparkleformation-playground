require 'base64'

SparkleFormation.dynamic(:auto_scaling_group) do |_name, _config = {}|

  resources("#{_name}_auto_scaling_group".to_sym) do
    type 'AWS::AutoScaling::AutoScalingGroup'
    properties do
      availability_zones ( _config[:availability_zones] ? _config[:availability_zones] : get_azs! )
      launch_configuration_name ref!(_config[:launch_configuration_name].to_sym)
      min_size _config[:min_size] || '1'
      max_size _config[:max_size] || '1'
      v_p_c_zone_identifier _array(*_config[:subnets].map { |x| ref!(x.gsub('-', '_').to_sym) })
      load_balancer_names _array( *_config[:load_balancer_names].map { |x| ref!(x.to_sym) } )
      tags _array(
        -> {
          key 'Name'
          value join!('bentis', _name, ref!(:Environment), :options => { :delimiter => '-' })
          propagate_at_launch true
        },
        -> {
          key 'Environment'
          value ref!(:Environment)
          propagate_at_launch true
        },
        -> {
          key 'Role'
          value _name
          propagate_at_launch true
        },
        -> {
          key 'Department'
          value 'web'
          propagate_at_launch true
        },
        -> {
          key 'Project'
          value 'babel'
          propagate_at_launch true
        },
      )
    end
  end

  outputs do
    instance_id do
      description 'Name of the autoscaling configuration'
      value _cf_ref("#{_name}_auto_scaling_group".to_sym)
    end
  end
end

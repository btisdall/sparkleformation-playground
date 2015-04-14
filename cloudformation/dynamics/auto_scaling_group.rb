require 'base64'

SparkleFormation.dynamic(:auto_scaling_group) do |_name, _config = {}|

  resources("#{_name}_auto_scaling_group".to_sym) do
    type 'AWS::AutoScaling::AutoScalingGroup'
    properties do
      availability_zones ( _config[:availability_zones] ? _array(*_config[:availability_zones]) : get_azs! )
      launch_configuration_name _config[:launch_configuration_name]
      min_size _config[:min_size] || '1'
      max_size _config[:max_size] || '1'
      v_p_c_zone_identifier _array(*_config[:vpc_zone_identifier])
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
      value _cf_ref(_name)
    end
  end
end

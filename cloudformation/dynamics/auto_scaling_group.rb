require 'base64'

SparkleFormation.dynamic(:auto_scaling_group) do |_name, _config = {}|

  mappings.region_to_az_map do
    _set('us-east-1'._no_hump,    :zones => %w(a b c d e).map { |x| "us-east-1#{x}" })
    _set('us-west-1'._no_hump,    :zones => %w(a b c).map { |x|     "us-west-1#{x}" })
    _set('us-west-2'._no_hump,    :zones => %w(a b c).map { |x|     "us-west-2#{x}" })
    _set('eu-west-1'._no_hump,    :zones => %w(a b c).map { |x|     "eu-west-1#{x}" })
    _set('eu-central-1'._no_hump, :zones => %w(a b c).map { |x|  "eu-central-1#{x}" })
  end

  resources(_name.to_sym) do
    type 'AWS::AutoScaling::AutoScalingGroup'
    properties do
      availability_zones _cf_map(:region_to_az_map, 'AWS::Region', 'zones'._no_hump)
      launch_configuration_name _config[:launch_configuration_name]
      min_size _config[:min_size] || '1'
      max_size _config[:max_size] || '1'
      vpc_zone_identifier _array(*_config[:vpc_zone_identifier])
      tags _array(
        -> {
          key 'Name'
          value join!('bentis', _config[:role_tag], ref!(:Environment), :options => { :delimiter => '-' })
          propagate_at_launch true
        },
        -> {
          key 'Environment'
          value ref!(:Environment)
          propagate_at_launch true
        },
        -> {
          key 'Role'
          value _config[:role_tag]
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
      description 'Name of the launch configuration'
      value _cf_ref(_name)
    end
  end
end

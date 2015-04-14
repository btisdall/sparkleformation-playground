require 'base64'

SparkleFormation.dynamic(:babel_general_asg) do |_name, _config = {}|

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
      tags _array(
        -> {
          key 'Environment'
          value ref!(:Environment)
          propagate_at_launch true
        },
        -> {
          key 'Role'
          value ref!(:Role)
          propagate_at_launch true
        },
        -> {
          key 'Department'
          value 'web'
          propagate_at_launch true
        },
        -> {
          key 'Name'
          value join!('bentis', ref!(:Role), ref!(:Environment), 'other', :options => { :delimiter => '-' })
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

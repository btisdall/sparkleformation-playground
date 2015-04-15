SparkleFormation.dynamic(:subnet) do |_name, _config = {}|
  # _config[:az] must be set to an availability zone
  # _config[:type] is either :public or :private
  # _config[:route_tables] should be set to a list of route tables

  if _config.fetch(:type, :public) == :private
    resources("#{_name}_route_table".gsub('-','_').to_sym) do
      type 'AWS::EC2::RouteTable'
      properties do
        vpc_id ref!(:vpc)
        tags _array(
          -> {
            key 'Name'
            value "#{_name}_route_table".gsub('-','_').to_sym
          }
        )
      end
    end
    _config[:route_tables] ||= [ "#{_name}_route_table".gsub('-','_').to_sym ]
  else
    _config[:route_tables] ||= [ :default_route_table ]
  end

  resources("#{_name}_subnet".gsub('-','_').to_sym) do
    type 'AWS::EC2::Subnet'
    properties do
      vpc_id ref!(:vpc)
      availability_zone _config[:az]
      cidr_block _config[:cidr_block]
      tags _array(
        -> {
          key 'Name'
          value join!("#{_name}_subnet".gsub('-','_'), _config[:cidr_block].gsub('.', '_').gsub('/', '_'), :options => { :delimiter => '_' })
        },
        -> {
          key 'Network'
          value "#{_config[:type]}".capitalize
        }
      )
    end
  end

  _config[:route_tables].each do |rt|
    resources("#{_name}_#{rt.to_s}_association".gsub('-','_').to_sym) do
      type 'AWS::EC2::SubnetRouteTableAssociation'
      properties do
        subnet_id ref!("#{_name}_subnet".gsub('-','_').to_sym)
        route_table_id ref!(rt)
      end
    end
  end
end

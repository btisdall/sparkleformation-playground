SparkleFormation.build do
  set!('AWSTemplateFormatVersion', '2010-09-09')

  parameters do
    key_name do
      description 'Name of an existing EC2 KeyPair to enable SSH access to the instance'
      type 'String'
      default 'bentis-no-pp'
    end
    environment do
      description 'Environment eg "test", "production"'
      type 'String'
      allowed_values %w(test staging production)
    end
    default_instance_type do
      description 'Instance type eg "m3.large"'
      type 'String'
      default 'm3.medium'
    end
    vpc do
      description 'ID of VPC in which resources will be created'
      type 'String'
      default 'vpc-887645e5'
    end
    default_route_table do
      description 'ID of default route table'
      type 'String'
      default 'rtb-8a7645e7'
    end
  end
end

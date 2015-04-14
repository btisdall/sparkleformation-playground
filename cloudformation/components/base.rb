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
  end
end

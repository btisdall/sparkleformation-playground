SparkleFormation.build do
  set!('AWSTemplateFormatVersion', '2010-09-09')

  parameters do
    key_pair do
      description 'Name of an existing EC2 KeyPair to enable SSH access to the instance'
      type 'String'
      default 'bentis-no-pp'
    end
    environment do
      description 'Environment eg "test", "production"'
      type 'String'
      allowed_values %w(test staging production)
    end
    role do
      description 'Role eg "web", "cache"'
      type 'String'
      default 'session-cache'
    end
    instance_type do
      description 'Instance type eg "m3.large"'
      type 'String'
    end
  end
end

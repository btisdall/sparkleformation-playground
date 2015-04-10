SparkleFormation.new('ec2_example') do
  description "AWS CloudFormation Sample Template EC2InstanceSample..."

  parameters do
    key_name do
      description 'Name of an existing EC2 KeyPair to enable SSH access to the instance'
      type 'String'
    end
    environment do
      description 'Environment eg "test", "production"'
      type 'String'
    end
    role do
      description 'Role eg "web", "cache"'
      type 'String'
    end
  end

  mappings.region_map do
    _set('us-east-1'._no_hump, :ami => 'ami-eab68a82')
    _set('us-west-1'._no_hump, :ami => 'ami-951945d0')
    _set('us-west-2'._no_hump, :ami => 'ami-ff6182bb')
    _set('eu-west-1'._no_hump, :ami => 'ami-4d5b707d')
    _set('sa-east-1'._no_hump, :ami => 'ami-cd43f9d0')
    _set('ap-southeast-1'._no_hump, :ami => 'ami-0e586a5c')
    _set('ap-northeast-1'._no_hump, :ami => 'ami-420ff642')
  end

  resources do
    my_instance do
      type 'AWS::EC2::Instance'
      properties do
        key_name _cf_ref(:key_name)
        image_id _cf_map(:region_map, 'AWS::Region', :ami)
        instance_type('m3.medium')
        user_data _cf_base64('Hello!')
        tags _array(
          -> {
            key 'Environment'
            value ref!(:Environment)
          },
          -> {
            key 'Role'
            value ref!(:Role)
          },
          -> {
            key 'Department'
            value 'web'
          },
          -> {
            key 'Name'
            value join!('bentis', ref!(:Role), ref!(:Environment), 'other', :options => { :delimiter => '-' })
          },
          -> {
            key 'Project'
            value 'babel'
          },
        )
      end
    end
  end

  outputs do
    instance_id do
      description 'InstanceId of the newly created EC2 instance'
      value _cf_ref(:my_instance)
    end
    az do
      description 'Availability Zone of the newly created EC2 instance'
      value _cf_attr(:my_instance, :availability_zone)
    end
    public_ip do
      description 'Public IP address of the newly created EC2 instance'
      value _cf_attr(:my_instance, :public_ip)
    end
    private_ip do
      description 'Private IP address of the newly created EC2 instance'
      value _cf_attr(:my_instance, :private_ip)
    end
    public_dns do
      description 'Public DNSName of the newly created EC2 instance'
      value _cf_attr(:my_instance, :public_dns_name)
    end
    private_dns do
      description 'Private DNSName of the newly created EC2 instance'
      value _cf_attr(:my_instance, :private_dns_name)
    end
  end
end

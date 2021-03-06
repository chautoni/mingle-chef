include_recipe 'aws'

node[:deploy].each do |app_name, deploy_config|
  aws_access_key_id = deploy_config[:application_variables][:aws_access_key_id]
  aws_secret_access_key = deploy_config[:application_variables][:aws_secret_access_key]
  app_config_path = "#{deploy_config[:deploy_to]}/shared/config"

  directory app_config_path do
    action :create
    recursive true
  end

  aws_s3_file '/etc/rsyslog.conf' do
    bucket node[:mingle][:s3_configuration_bucket]
    remote_path 'rsyslog.conf'
    aws_access_key_id aws_access_key_id
    aws_secret_access_key aws_secret_access_key
  end

  execute 'restart rsyslog' do
    command 'service rsyslog restart'
  end

  ['apple_push_notification.pem', 'application.yml', 'redis.yml', 'pusher.yml'].each do |file_name|
    aws_s3_file "#{app_config_path}/#{file_name}" do
      bucket node[:mingle][:s3_configuration_bucket]
      remote_path file_name
      aws_access_key_id aws_access_key_id
      aws_secret_access_key aws_secret_access_key
    end
  end
end

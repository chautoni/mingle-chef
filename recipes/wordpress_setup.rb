include_recipe 'aws'

node[:deploy].each do |app_name, deploy_config|
  aws_access_key_id = deploy_config[:application_variables][:aws_access_key_id]
  aws_secret_access_key = deploy_config[:application_variables][:aws_secret_access_key]
  app_config_path = "#{deploy_config[:deploy_to]}/shared/config"
  file_name = 'wp-config.php'

  directory app_config_path do
    action :create
    recursive true
  end

  aws_s3_file "#{app_config_path}/#{file_name}" do
    bucket node[:mingle][:s3_configuration_bucket]
    remote_path file_name
    aws_access_key_id aws_access_key_id
    aws_secret_access_key aws_secret_access_key
  end
end




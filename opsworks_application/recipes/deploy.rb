include_recipe 'aws'

node[:deploy].each do |app_name, deploy_config|
  aws_s3_file "#{deploy_config[:deploy_to]}/current/config/apple_push_notification.pem" do
    bucket 'mingle-apn'
    remote_path 'apple_push_notification.pem'
    aws_access_key_id deploy_config[:application_variables][:aws_access_key_id]
    aws_secret_access_key deploy_config[:application_variables][:aws_secret_access_key]
  end

  template "#{deploy_config[:deploy_to]}/current/config/application.yml" do
    source "application.yml.erb"
    cookbook "opsworks_application"
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    variables(:application => deploy_config[:application_variables] || {})

    not_if do
      deploy_config[:application_variables].blank?
    end
  end
end

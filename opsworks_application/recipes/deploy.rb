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

  template "#{deploy_config[:deploy_to]}/current/config/redis.yml" do
    source "redis.yml.erb"
    cookbook "opsworks_application"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    # define variable .@redis. to be used in the ERB template
    variables(:redis => deploy_config[:redis] || {})

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:redis].blank?
    end
  end

  template "#{deploy_config[:deploy_to]}/current/config/pusher.yml" do
    source "pusher.yml.erb"
    cookbook "opsworks_application"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    # define variable .@redis. to be used in the ERB template
    variables(:pusher => deploy_config[:pusher] || {})

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:pusher].blank?
    end
  end
end

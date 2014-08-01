node[:deploy].each do |appname, deploy_config|
  approot = "#{deploy_config[:deployto]}/current"

  template "#{approot}/config/redis.yml" do
    source "redis.yml.erb"
    cookbook "opsworks_redis"

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
end

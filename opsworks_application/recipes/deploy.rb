node[:deploy].each do |appname, deploy_config|
  template "#{deploy_config[:deploy_to]}/current/config/application.yml" do
    source "application.yml.erb"
    cookbook "opsworks_application"
    mode "0660"
    group deploy_config[:group]
    owner deploy_config[:user]

    variables(:application => deploy_config[:application] || {})

    not_if do
      deploy_config[:application].blank?
    end
  end
end

node[:deploy].each do |application, deploy|
  if deploy['sidekiq']
    release_path = ::File.join(deploy[:deploy_to], 'current')
    sidekiq_env = deploy['sidekiq']['environment'] || 'production'

    template "setup sidekiq.conf" do
      path "/etc/init/sidekiq-#{application}.conf"
      source "sidekiq.conf.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        release_path: release_path,
        sidekiq_env: sidekiq_env
      })
    end

    service "sidekiq-#{application}" do
      provider Chef::Provider::Service::Upstart
      supports stop: true, start: true, restart: true, status: true
    end

    bash 'restart_sidekiq' do
      code "echo noop"
      notifies :restart, "service[sidekiq-#{application}]"
    end

  end
end

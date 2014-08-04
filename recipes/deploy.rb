node[:deploy].each do |app_name, deploy_config|
  release_path = ::File.join(deploy_config[:deploy_to], 'current')
  rails_env = deploy_config[:rails_env]

  execute 'clear application cache' do
    cwd release_path
    command 'bundle exec rake memcache:flush'
    environment 'RAILS_ENV' => rails_env
  end
end

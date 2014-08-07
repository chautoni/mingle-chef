execute 'changing to PST timezone' do
  command "echo 'US/Pacific' | sudo tee /etc/timezone"
end

execute 'making changes persisting' do
  command 'dpkg-reconfigure --frontend noninteractive tzdata'
end

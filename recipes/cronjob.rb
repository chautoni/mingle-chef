cron 'daily report' do
  hour '0'
  minute '30'
  day '*'
  command "sudo su - deploy -c 'cd /srv/www/mingle/current && RAILS_ENV=production bundle exec thor report_task:daily_system_report 2>&1'"
end

cron 'weekly unread messages notification' do
  hour '0'
  minute '30'
  weekday '1'
  command "sudo su - deploy -c 'cd /srv/www/mingle/current && RAILS_ENV=production bundle exec rake users:send_unread_messages_reminder 2>&1'"
end

cron 'checking background job status' do
  minute '15'
  hour '*'
  command "sudo su - deploy -c \'cd /srv/www/mingle/current && bundle exec rails runner -e production 'SystemMonitor::BackgroundJobMonitor.execute' 2>&1\'"
end

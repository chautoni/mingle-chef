cron 'daily report' do
  hour '0'
  minute '30'
  day '*'
  command 'cd /srv/www/mingle/current && RAILS_ENV=production bundle exec thor report_task:daily_system_report'
end

cron 'weekly unread messages notification' do
  hour '0'
  minute '30'
  weekday '1'
  command 'cd /srv/www/mingle/current && RAILS_ENV=production bundle exec rake users:send_unread_messages_reminder'
end

cron 'checking background job status' do
  minute '10'
  command "cd /srv/www/mingle/current && bundle exec rails runner -e production 'SystemMonitor::BackgroundJobMonitor.execute'"
end

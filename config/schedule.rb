env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
set :output, '/var/www/cron.log'

every 1.day, :at => '10:00 pm' do
  rake 'contact_manager:push_ldap_contacts'
end

every 1.day, :at => '11:00 pm' do
  rake 'contact_manager:pull_ldap_contacts'
end

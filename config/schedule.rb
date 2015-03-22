# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

def wrap_with_lockrun(command)
  # NB: Temporary hack using /usr/local/bin/lockrun
  # TODO: Make it work using the following command (issue with /usr/bin/env, what does this do?)
  #/usr/bin/env lockrun
  "/usr/local/bin/lockrun --lockfile=:path/tmp/:lockfile.lockrun --quiet -- sh -c \"#{ command }\""
end

rails_root = File.expand_path("#{File.dirname(__FILE__)}/..")

set :job_template, "/bin/bash -l -i -c ':job' > crondebug.log 2>&1"
job_type :lockrun_rake, wrap_with_lockrun('cd :path && RAILS_ENV=production bundle exec rake :task :output')
job_type :backup_command, "cd ~/Backup && ARCHIVE_ROOT=#{rails_root} RAILS_ENV=:environment backup perform :task :output"

every 1.day, :at => '10:00 pm' do
  lockrun_rake('contact_manager:push_ldap_contacts', lockfile: 'sync_contacts')
end

every 1.day, :at => '11:00 pm' do
  lockrun_rake('contact_manager:pull_ldap_contacts', lockfile: 'sync_contacts')
end

every 1.day, :at => '1:00 am' do
  backup_command "--trigger contactapp_db --root_path #{rails_root} --config_file backup/config.rb"
end
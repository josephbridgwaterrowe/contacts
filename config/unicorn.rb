root =  File.expand_path('../../', __FILE__)
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"

listen '/tmp/unicorn.contacts.sock'

if ENV['RAILS_ENV'] == 'development'
  worker_processes 1
else
  stderr_path "#{root}/log/unicorn.log"
  stdout_path "#{root}/log/unicorn.log"

  worker_processes 2
end
timeout 30

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end

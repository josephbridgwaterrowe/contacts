lock '3.2.1'

set :application, 'contact-manager'
set :repo_url, ''

set :branch, 'master'

set :user, ''
set :deploy_to, ''

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.2@contact-app'

set :linked_files, %w{config/application.yml config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :service, :unicorn, :upgrade

      within release_path do
        execute :bundle, :exec, :whenever, '--write-crontab'
      end
    end
  end

  after :publishing, :restart
end

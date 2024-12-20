# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "redmine-rubydev-vn"
set :repo_url, "git@github.com:rubydev-vn/redmine-rubydev-vn.git"
set :deploy_user, ENV.fetch("DEPLOY_USER", "")

if File.exist?(".ruby-version")
  set :ruby_version, File.read(".ruby-version").strip
else
  set :ruby_version, ENV.fetch("RUBY_VERSION", "3.3.6")
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key", "config/credentials.yml.enc", "config/puma.rb",
                      "config/additional_environment.rb", "config/configuration.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/pdf", "vendor", "storage",
                    "public/system", "public/assets", "public/uploads", "public/plugin_assets"

# Default value for default_env is {}
set :default_env, { path: "/home/#{fetch(:deploy_user)}/.local/share/mise/installs/ruby/#{fetch(:ruby_version)}/bin:$PATH" }

# Default value for local_user is ENV["USER"]
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Skip backup of assets manifest file
Rake::Task["deploy:assets:backup_manifest"].clear_actions

after "deploy:publishing", "puma:restart"

require 'rubygems'
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'
load 'config/capistrano-recipes/deploy'
load 'config/capistrano-recipes/utils/unicorn'
load 'config/capistrano-recipes/apps/rails_turbo_assets'

set :capistrano_extensions, [:multistage, :git, :mysql, :rails, :unicorn, :servers]
set :scm, :git
set :git_enable_submodules, 1

set :shared_children, %w{ log public/system tmp/cache tmp/sessions sockets tmp/pids }

set :stages, ['development', 'staging', 'production']
set :deploy_via, :remote_cache
set :use_sudo, false
ssh_options[:forward_agent] = true
set :default_stage, "development"
set :user, "ironweb"
set :port, 22

# Whether or not use this hostname is the default and will be served using the server IP address.
set :default_server_domain, false

set :copy_exclude, %w( .git .gitignore )
set :keep_releases, 10

# Enable local gem installs
default_environment['GIT_DISCOVERY_ACROSS_FILESYSTEM'] = "1"

set :normalize_asset_timestamps, false

# Project configurations
set :application, "rouges"
set :repository,  "git@github.com:ironweb/rouges.git"
set :branch, "master"
set :rake, "bundle exec rake"

# Ignore first level .git only as bundled submodules must be git repo
set :copy_exclude, %w( ./.git .gitignore doc/ config/deploy.rb config/deploy Capfile)

# RVM setup
set :rvm_ruby_string, '1.9.3'

# Unicorn
after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'
after 'deploy:restart', 'unicorn:restart'

before "deploy:assets:precompile", "deploy:link_configs"

# Clean up old revisions
after 'deploy', 'deploy:cleanup'

namespace :deploy do
  desc "Link all the config files to the shard directory"
  task :link_configs do
    run "ln -sf #{File.join(shared_path, 'config', 'database.yml')} #{File.join(latest_release, 'config')} " +
      "&& ln -sf #{File.join(shared_path, 'config', 'unicorn.rb')} #{File.join(latest_release, 'config')} " +
      "&& ln -sf #{File.join(shared_path, 'config', 'open311.yml')} #{File.join(latest_release, 'config')}"
  end
end

namespace :unicorn do
  desc "Generate unicorn configuration"
  task :setup, :roles => :web, :except => { :no_release => true } do
    require 'erb'
    run "mkdir -p #{File.join(shared_path, 'config')}"
    template = File.read(File.join(File.dirname(__FILE__), 'unicorn.rb.erb'))
    result = ERB.new(template).result(binding)
    put result, "#{shared_path}/config/unicorn.rb", :mode => 0644
  end
end

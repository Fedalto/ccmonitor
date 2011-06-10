require 'bundler/capistrano'

set :user, "eggbuild"
set :app_server, "metrics.gid.gap.com"

set :application, "ccmonitor"
set :branch, "master"
set :scm, :git
set :deploy_to, "/home/#{user}/#{application}"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "/tmp/ccmonitor.pid"
set :use_sudo, false
set :repository, "https://github.com/juanibiapina/ccmonitor.git"

server app_server, :app

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_config} -E production -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

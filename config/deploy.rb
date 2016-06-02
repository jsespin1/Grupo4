# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'Grupo4'
set :repo_url, 'git@github.com:jsespin1/Grupo4.git'

set :passenger_restart_with_touch, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/administrator/Grupo4'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

#Lo que viene sirve para linkear el archivo database.yml para otro no en producción. Ya que no queremos hacer
#Porq no queremos hacer override de database.yml cada vez que se haga deploy. Lo mismo con dir

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
	desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  task :set_spree do
    run "rake spree_auth:admin:create"
    run "rake db:seed"
  end

  after :publishing, 'deploy:restart'
  after :publishing, 'deploy:set_spree'
  after :finishing, 'deploy:cleanup'


  #Lo que se comenta a continuacion era lo por Default
  #after :restart, :clear_cache do
    #on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as: comentado siempre
      # within release_path do comentado siempre
      #   execute :rake, 'cache:clear' comentado siempre
      # end
    #end
  #end

end

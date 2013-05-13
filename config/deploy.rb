default_run_options[:pty] = true
set :application, "byop"

#set :repository, "git@bitbucket.org:emclab2011/byop.git"
set :scm, :git

set :use_sudo, false

set :branch, "master"
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
#set :rails_env, 'production'
set :keep_releases, 3
ssh_options[:paranoid] = false
ssh_options[:port] = 22

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user  # Don't use system-wide RVM

#
#set :default_environment, {
#  'PATH' => "/home/cjadmin/.rvm/rubies/ruby-1.9.3-p194/bin/:/home/ubuntu/.rvm/bin/:$PATH",
#  'RUBY_VERSION' => 'ruby 1.9.3',
#  'GEM_HOME'     => '/home/ubuntu/.rvm/rubies/ruby-1.9.3-p194/',
#  'GEM_PATH'     => '/home/ubuntu/.rvm/rubies/ruby-1.9.3-p194/bin',
#  'BUNDLE_PATH'  => '/home/ubuntu/.rvm/gems/ruby-1.9.3-p194/bin/',  # If you are using bundler.
#  'RAKE_PATH'    => '/home/ubuntu/.rvm/gems/ruby-1.9.3-p194/bin/'
#}


#set :deploy_via, :remote_cache

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
#after "deploy", "deploy:bundle_gems"
#after "deploy:bundle_gems", "deploy:restart"

after "deploy", "deploy:copy_files"

 namespace :deploy do
   #task :bundle_gems do
    # run "cd #{deploy_to}/current && rvmsudo /home/cjadmin/.rvm/gems/ruby-1.9.3-p125/bin/bundle install vendor/gems"
   #end
   task :gems, :roles => :web, :except => { :no_release => true } do 
     #run "cd #{current_path}; #{shared_path}/bin/bundle unlock" 
     run "cd #{current_path}; nice -19 #{shared_path}/bin/bundle install vendor/" # nice -19 is very important otherwise DH will kill the process! 
     #run "cd #{current_path}; #{shared_path}/bin/bundle lock" 
   end #this task make the uploading possible, after 2 days works which did not going anywhere about missing gem bundler.
   
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   
   task :copy_files,:roles => :app do
     #run "cp /home/cjadmin/shared/production.rb /var/www/byop/current/config/environments/production.rb"
     #run "cp /home/cjadmin/shared/database.yml /var/www/byop/current/config/database.yml"
     #run "cp /home/cjadmin/shared/Gemfile /var/www/byop/current/Gemfile"
 
   end
   
 end

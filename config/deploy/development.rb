server "ec2-54-242-58-88.compute-1.amazonaws.com", :web, :app, :db, :primary=>true
set :hostname, "ec2-54-242-58-88.compute-1.amazonaws.com"
set :deploy_to, "/home/ironweb/web/development/"
set :branch, "master"

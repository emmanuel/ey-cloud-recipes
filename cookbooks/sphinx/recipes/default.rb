#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
#
# All rights reserved - Do Not Redistribute
#

link "/etc/sphinx.conf" do
  to "/data/rubyflow/shared/config/sphinx.conf"
end

directory "/var/log/engineyard/sphinx/rubyflow/indexes" do 
  owner 'deploy'
  group 'deploy'
  mode 0775
  recursive true
end

directory "/var/run/sphinx" do 
  owner 'deploy'
  group 'deploy'
  mode 0775
  recursive true
end

directory "/data/rubyflow/shared/config/thinkingsphinx" do 
  owner 'deploy'
  group 'deploy'
  mode 0775
  recursive true
end

monitrc("sphinx", :app => rubyflow,
                  :user => 'deploy')
                  
template "/data/rubyflow/shared/config/sphinx.yml" do
  owner 'deploy'
  group 'deploy'
  mode 0644
  source "sphinx.yml.erb"
  variables({
    :env => 'production',
    :app => 'rubyflow',
    :port => 3312
  })
end

execute "fix-permissions-sphinx-rubyflow" do
  command %Q{
    chown -R deploy:deploy /var/log/engineyard/sphinx /var/run/sphinx /data/rubyflow/shared/config/thinkingsphinx /data/rubyflow/shared/config/sphinx.yml
  }
end
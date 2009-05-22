#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
#
# All rights reserved - Do Not Redistribute
#

link "/etc/sphinx.conf" do
  to "/data/#{app}/shared/config/sphinx.conf"
end

directory "/var/log/engineyard/sphinx/#{app}/indexes" do 
  owner node[:owner_name]
  group node[:owner_name]
  mode 0775
  recursive true
end

directory "/var/run/sphinx" do 
  owner node[:owner_name]
  group node[:owner_name]
  mode 0775
  recursive true
end

directory "/data/#{app}/shared/config/thinkingsphinx" do 
  owner node[:owner_name]
  group node[:owner_name]
  mode 0775
  recursive true
end

monitrc("sphinx", :app => app,
                  :user => node[:owner_name])
                  
template "/data/#{app}/shared/config/sphinx.yml" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  source "sphinx.yml.erb"
  variables({
    :env => node[:environment][:framework_env],
    :app => app,
    :port => 3312
  })
end

execute "fix-permissions-sphinx-#{app}" do
  command %Q{
    chown -R #{node[:owner_name]}:#{node[:owner_name]} /var/log/engineyard/sphinx /var/run/sphinx /data/#{app}/shared/config/thinkingsphinx /data/#{app}/shared/config/sphinx.yml
  }
end
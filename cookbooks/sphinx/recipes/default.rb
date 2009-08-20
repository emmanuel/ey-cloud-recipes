require 'pp'
#
# Cookbook Name:: thinking_sphinx
# Recipe:: default
#
#if_app_needs_recipe("thinking_sphinx") do |app,data,index|

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  directory "/var/run/sphinx" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/sphinx/#{node[:environment][:name]}" do
    recursive true
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  remote_file "/etc/logrotate.d/sphinx" do
    owner "root"
    group "root"
    mode 0755
    source "sphinx.logrotate"
    action :create
  end

  template "/etc/monit.d/sphinx.#{node[:environment][:name]}.monitrc" do
    source "sphinx.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :app_name => node[:environment][:name],
      :user => node[:owner_name]
    })
  end

  template "/data/#{node[:environment][:name]}/shared/config/sphinx.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sphinx.yml.erb"
    variables({
      :app_name => node[:environment][:name],
      :user => node[:owner_name]
    })
  end

end

require 'pp'
#
# Cookbook Name:: thinking_sphinx
# Recipe:: default
#
#if_app_needs_recipe("thinking_sphinx") do |app,data,index|

run_for_app("ThinkingAboutSphinx") do |app_name, data|

  directory "/var/run/sphinx" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/sphinx/#{app_name}" do
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

  template "/etc/monit.d/sphinx.#{app_name}.monitrc" do
      source "sphinx.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :app => app_name,
        :user => node[:owner_name]
      })
  end

  template "/data/#{app_name}/shared/config/sphinx.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sphinx.yml.erb"
    variables({
      :app => app_name,
      :user => node[:owner_name]
    })
  end
  
  link "/data/#{app_name}/current/config/sphinx.yml" do
    to "/data/#{app_name}/shared/config/sphinx.yml"
  end

  link "/data/#{app_name}/current/config/thinkingsphinx" do
    to "/data/#{app_name}/shared/config/thinkingsphinx"
  end

end

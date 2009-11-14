#
# Cookbook Name:: thinking_sphinx
# Recipe:: default
#
# Run sphinx searchd on app instances
if ['solo', 'app', 'app_master'].include?(node[:instance_role])
  app_name = "NavigatingCancer"

  # for pid file
  directory "/var/run/sphinx" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  # for indexes
  directory "/var/cache/sphinx/indexes/#{app_name}" do
    recursive true
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

  bash "link-searchd-log-to-var-log" do
    code "ln -nfs /data/#{app_name}/shared/log/searchd.log /var/log/engineyard/sphinx/#{app_name}/searchd.log"
  end

  bash "link-query-log-to-var-log" do
    code "ln -nfs /data/#{app_name}/shared/log/query.log /var/log/engineyard/sphinx/#{app_name}/query.log"
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
    owner "root"
    group "root"
    mode 0644
    variables({
      :app_name => app_name,
      :user => node[:owner_name]
    })
  end

  directory "/data/#{app_name}/shared/config" do
    recursive true
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  template "/data/#{app_name}/shared/config/sphinx.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sphinx.yml.erb"
    variables({
      :app_name => app_name,
      :user => node[:owner_name]
    })
  end

end

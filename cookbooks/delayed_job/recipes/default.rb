#
# Cookbook Name:: delayed_job
# Recipe:: default
#

# run DelayedJob worker on app instances
if ['solo', 'app', 'app_master'].include?(node[:instance_role])
  app_name = node[:applications].keys.first
  rails_env = node[:environment][:framework_env]
  worker_name = "delayed_job_worker_#{app_name}_#{rails_env}"

  directory "/var/run/delayed_job" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  directory "/var/log/engineyard/delayed_job/#{app_name}" do
    recursive true
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  remote_file "/etc/logrotate.d/delayed_job" do
    owner "root"
    group "root"
    mode 0755
    source "delayed_job.logrotate"
    action :create
  end

  template "/data/#{app_name}/shared/config/delayed_job.yml" do
    source "delayed_job.yml.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables({
      :app_name => app_name,
      :rails_env => rails_env,
      :worker_name => worker_name,
      :user => node[:owner_name]
    })
  end

  template "/etc/monit.d/#{worker_name}.monitrc" do
    source "delayed_job_worker.monitrc.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :app_name => app_name,
      :rails_env => rails_env,
      :worker_name => worker_name,
      :user => node[:owner_name]
    })
  end

end

#
# Cookbook Name:: whenever
# Recipe:: default
#
# Whenever defaults to production mode, so we generate a config file
if ['solo', 'app', 'app_master'].include?(node[:instance_role])
  app_name = "NavigatingCancer"

  directory "/data/#{app_name}/shared/config" do
    recursive true
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
  end

  template "/data/#{app_name}/shared/config/schedule.rb" do
    source "schedule.rb.erb"
    owner "navi"
    group "navi"
    mode 0644
    variables({
      :app_name  => app_name,
      :rails_env => @node[:environment][:framework_env],
    })
  end

end

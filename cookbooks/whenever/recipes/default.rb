#
# Cookbook Name:: whenever
# Recipe:: default
#
# Whenever defaults to production mode, so we generate a config file
if ['solo', 'app', 'app_master'].include?(node[:instance_role])
  app_name = "NavigatingCancer"

  template "/data/#{app_name}/shared/schedule.rb" do
    source "schedule.rb.erb"
    owner "navi"
    group "navi"
    mode 0644
    variables({
      :app_name => app_name,
      :rails_env => @node[:environment][:framework_env],
    })
  end

end

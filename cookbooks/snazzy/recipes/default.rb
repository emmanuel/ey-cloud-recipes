#
# Cookbook Name:: snazzy
# Recipe:: default
#

directory "/etc/snazzy/pants" do
  owner 'root'
  group 'root'
  mode 0775
  recursive true
end
#
# Cookbook Name:: ssmtp
# Recipe:: default
#

if ['db_master', 'db_slave', 'solo'].include?(node[:instance_role])

  directory "/etc/ssmtp" do
    recursive true
    action :delete
  end

  directory "/data/ssmtp" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    not_if "test -d /data/ssmtp"
  end

  link "/etc/ssmtp" do
    to '/data/ssmtp'
  end

end

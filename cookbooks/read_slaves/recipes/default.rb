#
# Cookbook Name:: read_slaves
# Recipe:: default
#

node.engineyard.apps.each do |app|
  template "/data/#{app.name}/shared/config/shards.yml" do
    # adapter: postgres   => datamapper
    # adapter: postgresql => active record
    dbtype = case node.engineyard.environment.db_stack
             when DNApi::DbStack::Mysql     then node.engineyard.environment.ruby_component.mysql_adapter
             when DNApi::DbStack::Postgres  then 'postgresql'
             when DNApi::DbStack::Postgres9 then 'postgresql'
             end

    owner node.engineyard.environment.ssh_username
    group node.engineyard.environment.ssh_username
    mode 0655
    source "shards.yml.erb"
    variables({
      :environment => node.engineyard.environment.framework_env,
      :dbuser => node.engineyard.environment.ssh_username,
      :dbpass => node.engineyard.environment.ssh_password,
      :dbname => app.database_name,
      :dbtype => dbtype,
      :slaves => node.engineyard.environment.db_slaves_hostnames
    })
  end
end

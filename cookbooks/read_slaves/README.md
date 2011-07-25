# SHORT DESCRIPTION:

Read Slaves Cookbook.

# DESCRIPTION:

This cookbook installs the shards.yml file required by the [Octopus database sharding gem](https://github.com/tchandy/octopus). This is for a simple read slave configuration where all slaves are used for reads. Other configurations are possible, but this is the most straight-forward setup and does not require any additional code changes aside from installing the gem as described in the [Octopus README](https://github.com/tchandy/octopus).

# IMPORTANT NOTE

When using database replicas as read slaves, it's vitally important that they not fall too far behind or your users will start seeing old data that could adversely affect your application. Before using this recipe, you should install the [mysql replication check cookbook](https://github.com/engineyard/ey-cloud-recipes/tree/master/cookbooks/mysql_replication_check) and make sure it's working. Typically, slaves can stay in sync fairly well. Usually, you'll notice them lag behind due to either very long queries executing on the master database that then have to be executed on the slaves or due to heavy-weight migrations that complete on the master and then have to complete on the slaves as well.

# USAGE

Add this cookbook to your [custom recipes repo](http://docs.engineyard.com/custom-chef-recipes.html). You'll need to setup a deploy hook in your before_restart.rb deploy hook to symlink the shards.yml file to your app's config directory like this:

    run "ln -nfs #{shared_path}/config/shards.yml #{release_path}/config/shards.yml"

You can get more information about deploy hooks [here](http://docs.engineyard.com/use-deploy-hooks-with-engine-yard-appcloud.html). Assuming you setup added the Octopus gem to your application properly, all read queries should start automatically being sent to your database slaves.
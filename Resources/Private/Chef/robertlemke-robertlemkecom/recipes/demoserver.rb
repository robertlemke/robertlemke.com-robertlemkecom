#
# Cookbook Name:: typo3-singlesignon
# Recipe:: demoserver
#

include_recipe "typo3-singlesignon::flow_base"

include_recipe "database::mysql"

hostsfile_entry "127.0.0.1" do
  # TODO Use attr
  hostname "ssodemoserver.vagrant"
end

application "typo3-singlesignon-demoserver" do
  # TODO Use attr
  path "/usr/local/www/sites/ssodemoserver"
  owner node[:apache][:user]
  group node[:apache][:user]
  repository node['typo3-singlesignon']['demoserver']['repository']
  revision node['typo3-singlesignon']['demoserver']['revision']

  mod_php_apache2 do
    webapp_template "vhost.conf.erb"
    # TODO Use attr
    server_aliases ["ssodemoserver.vagrant"]
  end

  before_migrate do
    current_release = release_path

    # TODO Use attr
    composer current_release do
      action [:deploy, :install]
    end

    # TODO Use attr
    mysql_database 'ssodemoserver' do
      connection ({:host => "127.0.0.1", :username => 'root', :password => node['mysql']['server_root_password']})
      action :create
    end

    template "#{current_release}/Configuration/Settings.yaml" do
      # TODO Use attr
      source "demoserver/Settings.yaml.erb"
      owner node[:apache][:user]
      group node[:apache][:user]
      mode "0644"
      # notifies :restart, 'service[apache2]'
    end
  end

  migrate true
  migration_command "./flow doctrine:migrate && ./flow acme.demoserver:setup:setup"

  # Use force_deploy to run migrations even if on correct revision
  # action :force_deploy
end

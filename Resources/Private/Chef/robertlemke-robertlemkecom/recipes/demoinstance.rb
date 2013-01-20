#
# Cookbook Name:: typo3-singlesignon
# Recipe:: demoinstance
#

include_recipe "typo3-singlesignon::flow_base"

include_recipe "database::mysql"
include_recipe "apache2::mod_setenvif"

hostsfile_entry "127.0.0.1" do
  # TODO Use attr
  hostname "ssodemoinstance.vagrant"
  hostname "ssodemoinstance2.vagrant"
end

application "typo3-singlesignon-demoinstance" do
  # TODO Use attr
  path "/usr/local/www/sites/ssodemoinstance"
  owner node[:apache][:user]
  group node[:apache][:user]
  repository node['typo3-singlesignon']['demoinstance']['repository']
  revision node['typo3-singlesignon']['demoinstance']['revision']

  mod_php_apache2 do
    webapp_template "vhost-demoinstance.conf.erb"
    # TODO Use attr
    server_aliases ["ssodemoinstance.vagrant", "ssodemoinstance2.vagrant"]
  end

  before_migrate do
    current_release = release_path

    # TODO Use attr
    composer current_release do
      action [:deploy, :install]
    end

    # TODO Use attr
    mysql_database 'ssodemoinstance' do
      connection ({:host => "127.0.0.1", :username => 'root', :password => node['mysql']['server_root_password']})
      action :create
    end

    template "#{current_release}/Configuration/Settings.yaml" do
      # TODO Use attr
      source "demoinstance/Settings.yaml.erb"
      owner node[:apache][:user]
      group node[:apache][:user]
      mode "0644"
      # notifies :restart, 'service[apache2]'
    end

    directory "#{current_release}/Configuration/Production/Instance2" do
      owner node[:apache][:user]
      group node[:apache][:user]
      mode 00755
      recursive true
      action :create
    end

    template "#{current_release}/Configuration/Production/Instance2/Settings.yaml" do
      # TODO Use attr
      source "demoinstance/Production/Instance2/Settings.yaml.erb"
      owner node[:apache][:user]
      group node[:apache][:user]
      mode "0644"
      # notifies :restart, 'service[apache2]'
    end
  end


  migrate true
  migration_command "./flow doctrine:migrate && ./flow acme.demoinstance:setup:setup"

  # Use force_deploy to run migrations even if on correct revision
  # action :force_deploy
end

#
# Cookbook Name:: typo3-singlesignon
# Recipe:: flow_base
#

include_recipe "apt"
include_recipe "openssl"
include_recipe "apache2"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_apc"
include_recipe "php::module_curl"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "git"
include_recipe "composer"

# Add settings to php.ini through conf.d for cli and apache2
template "/etc/php5/conf.d/typo3-singlesignon.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[apache2]'
end

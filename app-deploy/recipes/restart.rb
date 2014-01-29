#
# Cookbook Name:: deploy
# Recipe:: web-restart

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action :restart
  end
  
  service 'php-fpm-5.5' do
    supports :status => true, :restart => true, :reload => true
    action :restart
  end
   
end
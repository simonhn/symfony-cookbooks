#
# Cookbook Name:: deploy
# Recipe:: php
#
include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  execute 'download_composer' do
    command 'curl -sS https://getcomposer.org/installer | php'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end

  execute 'install_composer_dependencies' do
    command 'php composer.phar install --no-scripts --no-dev --verbose --prefer-source --optimize-autoloader'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end

  execute 'build_boostrap' do
    command 'php vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php app'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end

  execute 'clear_cache' do
    command 'php app/console cache:clear --env=prod'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end

  execute 'assets_dump' do
    command 'php app/console assetic:dump --env=prod'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end

  execute 'remove_dev' do
    command 'rm web/app_dev.php'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:user]
  end
    
end

# 
# # Deploy the code
# deploy node['acme']['frontend']['deploy_dir'] do
#     scm_provider Chef::Provider::Git
#     repo node['acme']['frontend']['deploy_repo']
#     revision node['acme']['frontend']['deploy_branch']
#     if deploy_key
#         git_ssh_wrapper "#{node['acme']['frontend']['deploy_dir']}/git-ssh-wrapper"
#     end
#     user node['acme']['frontend']['php_fpm']['user']
#     group node['acme']['frontend']['php_fpm']['group']
#     symlink_before_migrate({})
#     purge_before_symlink ['data']
#     create_dirs_before_symlink []
#     # Removed due opsworks chef version
#     #rollback_on_error true
#     before_symlink do
#         # Copy vendors from latest release to avoid to fetch all dependencies with composer
#         ruby_block 'Copy vendors' do
#             block do
#                 current_release = "#{node['acme']['frontend']['deploy_dir']}/current"
#                 FileUtils.cp_r "#{current_release}/vendor", "#{deploy[:current_path]}/vendor" if File.directory? "#{current_release}/vendor"
#                 FileUtils.chown_R deploy[:user], deploy[:user], "#{deploy[:current_path]}/vendor" if File.directory? "#{current_release}/vendor"
#                 Chef::Log.info "Copying older vendors from #{current_release}/vendor to #{deploy[:current_path]}/vendor" if File.directory? "#{current_release}/vendor"
#                 Chef::Log.info 'Not copying vendor folders since it\'s not found in older release' unless File.directory? "#{current_release}/vendor"
#             end
#             action :create
#         end
# 
#         execute 'download_composer' do
#             command 'curl -sS https://getcomposer.org/installer | php'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
# 
#         execute 'install_composer_dependencies' do
#             command 'php composer.phar install --no-scripts --no-dev --verbose --prefer-source --optimize-autoloader'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
# 
#         execute 'build_boostrap' do
#             command 'php vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php app'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
# 
#         execute 'clear_cache' do
#             command 'php app/console cache:clear --env=prod'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
# 
#         execute 'assets_dump' do
#             command 'php app/console assetic:dump --env=prod'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
# 
#         execute 'remove_dev' do
#             command 'rm web/app_dev.php'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:user]
#         end
#     end
#     symlinks({"data" => "data"})
#     action :deploy
#     # Removed due opsworks chef version
#     #notifies :reload, "service[nginx]", :immediately
# end
# 
# # Restart php-fpm and nginx service
# service 'php5-fpm' do
#     supports :status => true, :restart => true, :reload => true
#     action [ :reload ]
# end
# 
# service 'nginx' do
#     supports :status => true, :restart => true, :reload => true
#     action [ :reload ]
# end
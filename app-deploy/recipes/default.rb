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
  
  directory "/root/.composer" do
    mode 0700
    owner "deploy"
    group "root"
    recursive true
  end

  template "/root/.composer/config.json" do
    source "composer.config.json.erb"
    mode 0644
    group "root"
    owner "deploy"
    variables(
      :github_api_key => (deploy[:github_api_key] rescue nil)
    )
  end
  template "#{deploy[:deploy_to]}/current/app/config/parameters.yml" do
    source "parameters.yml.erb"
    mode 0644
    group "root"
    owner "deploy"

    variables(
      :host => (deploy[:database][:host] rescue nil),
      :user => (deploy[:database][:user] rescue nil),
      :password => (deploy[:database][:password] rescue nil),
      :dbname => (deploy[:database][:dbname] rescue nil),
      :port => (deploy[:database][:port] rescue nil),
      :application => ("#{application}"  rescue nil),
      :thumbor_host => (deploy[:thumbor_host]  rescue nil),
      :thumbor_port => (deploy[:thumbor_port]  rescue nil),
      :thumbor_secret => (deploy[:thumbor_secret]  rescue nil)
    )
   only_if do
     File.directory?("#{deploy[:deploy_to]}/current/app/config")
   end
  end
  
  execute 'download_composer' do
    command 'curl -sS https://getcomposer.org/installer | php'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end

  execute 'install_composer_dependencies' do
    command 'php composer.phar install --no-scripts --no-dev --verbose --prefer-dist --optimize-autoloader'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end

  execute 'build_boostrap' do
    command 'php vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php app'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end

  execute 'clear_cache' do
    command 'php app/console cache:clear --env=prod'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end

  execute 'assets_dump' do
    command 'php app/console assetic:dump --env=prod'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end
  
  execute 'assets_install' do
    command 'app/console assets:install web --env=prod'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end
  
  execute 'log_cache_permissions' do
    cwd deploy[:current_path]
    command 'setfacl -R -m u:"nginx":rwX -m u:"deploy":rwX app/cache app/logs'
    user deploy[:user]
    group deploy[:group]
  end
  
  execute 'log_cache_permissions_1' do
    cwd deploy[:current_path]
    command 'setfacl -dR -m u:"nginx":rwX -m u:"deploy":rwX app/cache app/logs'
    user deploy[:user]
    group deploy[:group]
  end
  
  # execute 'remove_dev' do
  #   command 'rm web/app_dev.php'
  #   cwd deploy[:current_path]
  #   user deploy[:user]
  #   group deploy[:group]
  # end
  
  service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action :restart
  end
  
  service 'php-fpm-5.5' do
    supports :status => true, :restart => true, :reload => true
    action :restart
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
#             group deploy[:group]
#         end
# 
#         execute 'install_composer_dependencies' do
#             command 'php composer.phar install --no-scripts --no-dev --verbose --prefer-source --optimize-autoloader'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:group]
#         end
# 
#         execute 'build_boostrap' do
#             command 'php vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php app'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:group]
#         end
# 
#         execute 'clear_cache' do
#             command 'php app/console cache:clear --env=prod'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:group]
#         end
# 
#         execute 'assets_dump' do
#             command 'php app/console assetic:dump --env=prod'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:group]
#         end
# 
#         execute 'remove_dev' do
#             command 'rm web/app_dev.php'
#             cwd deploy[:current_path]
#             user deploy[:user]
#             group deploy[:group]
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
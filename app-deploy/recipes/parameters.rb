include_recipe 'deploy'
node[:deploy].each do |application, deploy|

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
      :application => ("#{application}"  rescue nil) 
    )
   only_if do
     File.directory?("#{deploy[:deploy_to]}/current/app/config")
   end
  end
end
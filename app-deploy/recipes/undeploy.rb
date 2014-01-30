include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  
  # link "#{node[:apache][:dir]}/sites-enabled/#{application}.conf" do
  #   action :delete
  #   only_if do
  #     ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application}.conf")
  #   end
  # end
  # 
  # file "#{node[:apache][:dir]}/sites-available/#{application}.conf" do
  #   action :delete
  #   only_if do
  #     ::File.exists?("#{node[:apache][:dir]}/sites-available/#{application}.conf")
  #   end
  # end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if do
      ::File.exists?("#{deploy[:deploy_to]}")
    end
  end
end
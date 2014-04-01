include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  execute 'ingest_services' do
    command 'app/console papi:ingest:service'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end
end
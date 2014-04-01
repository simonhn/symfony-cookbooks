include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  execute 'ingest_programs' do
    command 'app/console papi:ingest:programs'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end
end
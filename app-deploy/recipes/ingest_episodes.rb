include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  execute 'ingest_episodes' do
    command 'app/console papi:ingest:episodes'
    cwd deploy[:current_path]
    user deploy[:user]
    group deploy[:group]
  end
end
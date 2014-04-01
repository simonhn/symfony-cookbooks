execute 'ingest_episodes' do
  command 'app/console papi:ingest:episodes'
  cwd '/srv/www/doctrine/current/'
  user 'deploy'
end

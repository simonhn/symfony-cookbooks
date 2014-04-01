execute 'ingest_services' do
  command 'app/console papi:ingest:service'
  cwd '/srv/www/doctrine/current/'
  user 'deploy'
end
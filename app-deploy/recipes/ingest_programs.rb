execute 'ingest_programs' do
  command 'app/console papi:ingest:programs'
  cwd '/srv/www/doctrine/current/'
  user 'deploy'
end

execute 'migrate' do
  command 'app/console doctrine:migrations:migrate --no-interaction'
  cwd '/srv/www/doctrine/current/'
  user 'deploy'
end
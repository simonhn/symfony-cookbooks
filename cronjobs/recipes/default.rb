# 
# Cookbook Name:: cronjobs
# Recipe:: default
#
# Create custom cron jobs using configuration values in the Custom JSON
#

cron "ingest_programs_every_3_hours" do
  minute  "10"
  hour    "*"
  day     "*"
  month   "*"
  weekday "*"
  command "cd /srv/www/doctrine/current && app/console papi:ingest:programs"
  user    "deploy"
  action :create
end

# node[:deploy][:doctrine][:cron_jobs].each do |cron_values|
#   cron "#{cron_values[:name]}" do
#     minute  "#{cron_values[:minute]}"
#     hour    "#{cron_values[:hour]}"
#     day     "#{cron_values[:day]}"
#     month   "#{cron_values[:month]}"
#     weekday "#{cron_values[:weekday]}"
#     command "#{cron_values[:command]}"
#     user    "deploy"
#   end
# end
# 
# "cron_jobs": 
# [  
#   {
#       // Ingest programs every 3 hours
#       "name": "send_email_sunday_8",
#       "minute": "10", 
#       "hour":   "*/3", 
#       "month" :  "*",
#       "weekday": "*",
#       "command": "cd /srv/www/doctrine/current && app/console papi:ingest:programs" 
#   },
#   {
#       // Ingest episodes every hour
#       "name": "send_email_sunday_8",
#       "minute": "5", 
#       "hour":   "*", 
#       "month" :  "*",
#       "weekday": "*",
#       "command": "cd /srv/www/doctrine/current && app/console papi:ingest:programs" 
#   },
# ]
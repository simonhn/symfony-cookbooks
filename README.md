The home for the cookbooks used to bootstrap the instances for the programs api project running on opsworks.

This is the current deploy json that we use:
  {
    "opsworks":{
      "ruby_stack": "ruby",
      "deploy_user":{
        "group": "nginx"
      }
    },
    "deploy": {
      "doctrine":{
        "thumbor_host": "54.206.195.93",
        "thumbor_port": "8000",
        "thumbor_secret": "secret stuff",
        "musicapi":  "http://54.206.155.166/api/v1/music/",
        "github_api_key": "f88fe638313asadasd361692ff40a900dca3b7ac56",
        "database": {
          "dbname": "dbname", 
          "host": "mydatabase.abcd1234.region.rds.amazonaws.com", 
          "user": "username", 
          "password": "very secret",
          "port": "3306"
        }
      }
    }
  }
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
      "php_sample":{
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
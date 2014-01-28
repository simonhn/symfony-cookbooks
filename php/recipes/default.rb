# remove any existing php/mysql
execute "yum remove -y php* php-* mysql http* httpd-*"

# get the metadata
execute "yum -q makecache"

# Install php 5.5 from aws
execute "yum install -y php55 php55-devel php55-cli php55-snmp php55-soap php55-xml php55-xmlrpc php55-process php55-mysqlnd php55-pecl-memcache php55-opcache php55-pdo php55-imap php55-mbstring php55-intl php55-mbstring php55-mysqli"
# remove any existing php/mysql
execute "yum remove -y php* php-* mysql http* httpd-*"

# get the metadata
execute "yum -q makecache"

# Install php 5.5 from aws
# execute "yum install -y php55 php55-devel php55-cli php55-snmp php55-soap php55-xml php55-xmlrpc php55-process php55-mysqlnd php55-pecl-memcache php55-opcache php55-pdo php55-imap php55-mbstring php55-intl php55-mysqli"

package "php55" do
    action :install
end

package "php55-devel" do
    action :install
end

package "php55-cli" do
    action :install
end

package "php55-snmp" do
    action :install
end

package "php55-soap" do
    action :install
end

package "php55-xml" do
    action :install
end

package "php55-xmlrpc" do
    action :install
end

package "php55-process" do
    action :install
end

package "php55-mysqlnd" do
    action :install
end

package "php55-pecl-memcache" do
    action :install
end

package "php55-opcache" do
    action :install
end
package "php55-pdo" do
    action :install
end
package "php55-imap" do
    action :install
end

package "php55-mbstring" do
    action :install
end

package "php55-intl" do
    action :install
end

package "php55-fpm" do
  action :install
end

package "php55-pecl-apc" do
  action :install
end

service 'php-fpm-5.5' do
    supports :status => true, :restart => true, :reload => true
    action :start
end

# Point to the right php ini
execute "rm /etc/php-5.5.d/php.ini"
execute "ln -s /etc/php-5.5.ini /etc/php-5.5.d/php.ini"

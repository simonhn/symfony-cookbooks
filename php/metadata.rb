name              'php'
maintainer        'Simon, Inc.'
version           '1.0.0'

%w{ amazon }.each do |os|
  supports os
end

depends "build-essential"
depends "apt"
depends "yum"
depends 'yum-epel'
recipe "php", "Installs php"
# == Define: webserver::vhost
#
define webserver::vhost(
  $ensure           = 'present'
  $vhostname        = $name,
  $servername       = $::fqdn,
  $docroot_owner    = 'root',
  $docroot_group    = 'root',
  $serveradmin      = 'webmaster@sixt.com',
  $port             = '80',
  $docroot          = "/var/www/html/${name}",
  $managecontent    = true,
  $priority         = '25',
  $ssl              = undef,
  $serveralias      = undef,
  $options          = undef,
  $override         = undef,
  $db               = 'false',
  $dbname           = undef,
  $logroot,
){
  ### not sure if still needed :
  #  $vhost_data = $vhost_hash[$name]

##

  case $db {
    'true': {
      if $dbname {
        $dbname = $vhost_data['dbname']
        webserver::databases { [ $dbname ] :; }
      }
      else
      {
        fail('option db set to true but no dbname is given')
      }
    }
    'false': {
    }
    default: {
      fail("Unknown db value: ${db}")
    }
  }

  if $managecontent == true {
    apache::vhost { $name:
          ensure             => $ensure,
          port               => $port,
          docroot            => $docroot,
          docroot_owner      => $docroot_owner,
          docroot_group      => $docroot_group,
          serveradmin        => $serveradmin,
          ssl                => $ssl,
          priority           => $priority,
          servername         => $servername,
          serveraliases      => $serveralias,
          options            => $options,
          override           => $override,
          vhost_name         => $vhostname,
          logroot            => $logroot,
    }
  }
  else {
    file { "/etc/httpd/conf.d/${priority}-${name}.conf":
      ensure => 'present',
    }
  }
}

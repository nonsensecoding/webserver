# == Define: webserver::vhost
#
define webserver::vhost {

  $vhost_hash = hiera_hash('vhosts')
  $vhost_data = $vhost_hash[$name]

  $ensure             = 'present'
  $vhostname          = $name
  $servername         = $::fqdn
  $docroot_owner      = $vhost_data['docroot_owner']
  $docroot_group      = $vhost_data['docroot_group']
  $serveradmin        = $vhost_data['serveradmin']
  $ssl                = $vhost_data['ssl']
  $serveralias        = $vhost_data['serveralias']
  $options            = $vhost_data['options']
  $override           = $vhost_data['override']
  $logroot            = $vhost_data['logroot']
  #$priority          = $vhost_data['priority']
  #$port              = $vhost_data['port']
  #$docroot           = $vhost_data['docroot']
  #$managecontent     = $vhost_data['managecontent']
  #$db                = false
  #$dbname            = undef

  if $vhost_data['port'] { $port = $vhost_data['port'] } else { $port = '80' }
  if $vhost_data['docroot'] { $docroot = $vhost_data['docroot'] } else { $docroot = "/var/html/${name}" }
  if $vhost_data['managecontent'] { $managecontent = $vhost_data['managecontent'] } else { $managecontent = true }
  if $vhost_data['priority'] { $priority = $vhost_data['priority'] } else { $priority = '25' }

  if $vhost_data['db'] { $db = $vhost_data['db'] } else { $db = 'false' }
  case $db {
    'true': {
      if $vhost_data['dbname'] {
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

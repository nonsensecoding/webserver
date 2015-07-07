# == Class: webserver
#
# Webserver class calls apache module and realises the vhost given from hiera
#
class webserver (
  $httpd_ensure   = 'directory',
  $httpd_mode     = '0664',
  $httpd_owner    = 'root',
  $httpd_group    = 'apache',
  $httpd_recurse  = 'true',
  $dirs_owner     = 'root',
  $dirs_group     = 'apache',
  $dirs_mode      = '0664',
  $rdirs_owner    = 'root',
  $rdirs_group    = 'apache',
  $rdirs_mode     = '0664',
  $files_owner    = 'root',
  $files_group    = 'apache',
  $files_mode     = '0664',
  $webserver      = {},
  $webserver_type = 'apache',
)
{
  case $webserver_type {
    'apache': {  $httpd_basic = ['httpd', 'mod_ssl'] }
    default : { fail("Webserver is not supported! Currently supported webserver(s) are: apache")}
  }

  # get data specified in hiera
  $webserver_data = $webserver[$::hostname]

  # variables for host
  $packages     = $webserver_data['packages']
  $dirs         = $webserver_data['dirs']
  $rdirs        = $webserver_data['rdirs']
  $files        = $webserver_data['files']
  $vhosts       = $webserver_data['vhosts']

  case $managed {
    'true': {
      # get and realize vhost
      webserver::vhost {[ $vhosts ]:;}
    }
    'false': {
      # install apache
      package { $httpd_basic:
        ensure => present,
      }

      file { '/etc/httpd':
        ensure  => $httpd_ensure,
        mode    => $httpd_mode,
        owner   => $httpd_owner,
        group   => $httpd_group,
        recurse => $httpd_recurse,
      }
    }
    default: {
      fail('Webserver type not defined, set in hiera managed to true or false')
    }
  }

  # create resources defined in hiera
  package { $packages:
    ensure => present,
  }

  if $dirs {
    webserver::dirs {[ $dirs ]:
      owner => $dirs_owner,
      group => $dirs_group,
      mode  => $dirs_mode,
    }
  }
  if $rdirs {
    webserver::rdirs {[ $rdirs ]:
      owner => $rdirs_owner,
      group => $rdirs_group,
      mode  => $rdirs_mode,
    }
  }
  if $files {
    webserver::files {[ $files ]:
      owner => $files_owner,
      group => $files_group,
      mode  => $files_mode,
    }
  }
}

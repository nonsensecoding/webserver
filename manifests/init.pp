# == Class: webserver
#
# Webserver class calls apache module and realises the vhost given from hiera
#
class webserver (
  $httpd_ensure  = 'directory',
  $httpd_mode    = '0664',
  $httpd_owner   = 'root',
  $httpd_group   = 'apache',
  $httpd_recurse = 'true',
  $dirs_owner    = 'root',
  $dirs_group    = 'apache',
  $dirs_mode     = '0664',
  $rdirs_owner   = 'root',
  $rdirs_group   = 'apache',
  $rdirs_mode    = '0664',
  $files_owner   = 'root',
  $files_group   = 'apache',
  $files_mode    = '0664',
) {

  include packages

  # get data specified in hiera
  $webserver_hash = hiera_hash('web_server')
  $webserver_data = $webserver_hash[$::hostname]

  # variables for host
  $managed = $webserver_data['managed']
  $package_tags = $webserver_data['packages']
  $dirs = $webserver_data['dirs']
  $rdirs = $webserver_data['rdirs']
  $files = $webserver_data['files']

  case $managed {
    'true': {
      include apache
      # get and realize vhost
      $vhost = $webserver_data['vhost']
      webserver::vhost {[ $vhost ]:;}
    }
    'false': {
      # install apache
      Package <| tag == 'httpd_basic' |>

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
  Package <| tag == [ $package_tags ] |>

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

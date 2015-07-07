# == Define: webserver::dirs
#
define webserver::dirs (
  $owner = 'root',
  $group = 'apache',
  $mode  = '0664',
) {

  $dirsplit = split($name, '[,:]')
  $dirname = $dirsplit[0]
  if $dirsplit[1] { $dirowner = $dirsplit[1] } else { $dirowner = $owner }
  if $dirsplit[2] { $dirgroup = $dirsplit[2] } else { $dirgroup = $group }
  if $dirsplit[3] { $dirmode = $dirsplit[3] } else { $dirmode = $mode }

  file { $dirname :
    ensure  => 'directory',
    owner   => $dirowner,
    group   => $dirgroup,
    mode    => $dirmode,
    recurse => false,
  }
}

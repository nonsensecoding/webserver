# == Define: webserver::rdirs
#
define webserver::rdirs (
  $owner = 'root',
  $group = 'apache',
  $mode  = '0664',
) {

  $rdirsplit = split($name, '[,:]')
  $rdirname = $rdirsplit[0]
  if $rdirsplit[1] { $rdirowner = $rdirsplit[1] } else { $rdirowner = $owner }
  if $rdirsplit[2] { $rdirgroup = $rdirsplit[2] } else { $rdirgroup = $group }
  if $rdirsplit[3] { $rdirmode = $rdirsplit[3] } else { $rdirmode = $mode }

  file { $rdirname :
    ensure  => 'directory',
    owner   => $rdirowner,
    group   => $rdirgroup,
    mode    => $rdirmode,
    recurse => true,
  }
}

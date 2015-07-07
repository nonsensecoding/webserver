# == Define: webserver::files
#
define webserver::files (
  $owner = 'root',
  $group = 'apache',
  $mode  = '0664',
) {

  $filesplit = split($name, '[,:]')
  $filename = $filesplit[0]
  if $filesplit[1] { $fileowner = $filesplit[1] } else { $fileowner = $owner }
  if $filesplit[2] { $filegroup = $filesplit[2] } else { $filegroup = $group }
  if $filesplit[3] { $filemode = $filesplit[3] } else { $filemode = $mode }

  file { $filename :
    ensure  => 'file',
    mode    => $filemode,
    owner   => $fileowner,
    group   => $filegroup,
  }
}

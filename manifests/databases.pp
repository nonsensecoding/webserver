# == Define: webserver::databases
#
# hiera user interface to call database via hiera
#
define webserver::databases {
  $database_hash = hiera_hash('database')
  $database_data = $database_hash[$name]
  $ensure        = $database_data['ensure']
  $user          = $database_data['user']
  $password      = $database_data['password']
  $port          = $database_data['port']
  $host          = $database_data['host']
  $mysql_perl    = $database_data['mysql_perl']
  $mysql_java    = $database_data['mysql_java']
  $mysql_ruby    = $database_data['mysql_ruby']
  $mysql_php     = $database_data['mysql_php']

  if $database_data['provider'] {
    $provider = $database_data['provider']
  } else {
    $provider = 'mysql'
  }

  database { $name:
    ensure     => $ensure,
    provider   => $provider,
    user       => $user,
    password   => $password,
    port       => $port,
    host       => $host,
    mysql_perl => $mysql_perl,
    mysql_java => $mysql_java,
    mysql_ruby => $mysql_ruby,
    mysql_php  => $mysql_php,
  }
}

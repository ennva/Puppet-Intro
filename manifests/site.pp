node default {
  # This is how you defined a resource of type file
  # file {'/root/README':
  #  ensure  => file,
  # content => 'This is a readme file..',
  #  owner   => 'root'
  #}
  # This will generate a duplicate error has the resource is already defined with the same owner
  # file { '/root/README':
  #  owner => 'root',
  #}
}
node 'master.puppet.vm' {
  include role::master_server
  # add a location to save facter's report
  file {'/root/REPORT':
    ensure => file,
    content => $fqnd, #report a fully-qualified-name-domain of the node
  }
}

# matching all node starting with web string
node /^web/ {
  include role::app_server
}

# matching all node starting with db string
node /^db/ {
  include role::db_server
}

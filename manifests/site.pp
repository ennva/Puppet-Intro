node default {
  # This is how you defined a resource of type file
  file {'/root/README':
    ensure  => file,
    content => 'This is a readme file..',
    owner   => 'root'
  }
  # This will generate a duplicate error has the resource is already defined with the same owner
  # file { '/root/README':
  #  owner => 'root',
  #}
}

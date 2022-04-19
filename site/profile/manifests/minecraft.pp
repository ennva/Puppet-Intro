class profile::minecraft {
  #include minecraft #call of minecraft module withour parameter
  class {'minecraft':
    install_dir => '/srv/minecraft'
  }
  
}

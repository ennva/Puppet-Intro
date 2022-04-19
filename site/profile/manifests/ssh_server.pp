class profile::ssh_server {
  package {'openssh-server':
    ensure => present,
  }
  service {'sshd':
    ensure => 'running',
    enable => 'true',
  }
  ssh_authorized_key {'root@master.puppet.vm':
    ensure => present,
    user => 'root',
    type => 'ssh-rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC+8GdcB3zcxsNT0tUCpaA6pX4qPhTBtalQWT6t9bVXKQet/PRPmRti6WQDjwlL5UTDgBxX0eR3eDpy4NhV8peI9gcf6HGeHaI0fGDnJd2Px/d66ib52YjEeNoBtAZcb6340ep288baD9IVTWjmqKlnG5MukBIoc9xIIzO98xQSb0lH+HY/IvSs6xHBCi79SU3lqmTOzCZJLnlaehKjeWSNn5YJBblGEsXsbIJ0ZRm5K4Gwq9fMB1VZAF/7jjkYOr5gc6HZHL7cmqzadaPtxP3lnjx74ymzR5jE6aeE9KAEOtngQg6AGG83iB/VmoGqx49meomD0jTv29d1SeqHLtRX root@master.puppet.vm'
  }
}

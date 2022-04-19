# In init.pp the name of the clas should be the same as the module.Here minecraft
class minecraft {
  file {'/opt/minecraft':
    ensure => directory,
  }
  file {'/opt/minecraft/server.jar':
    ensure => file,
    source => 'https://launcher.mojang.com/mc/game/1.12.2/server/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar',
  }
  package {'java':
    ensure => present,
  }
  file {'/opt/minecraft/eula.txt':
    ensure => file,
    content => 'eula=true',
  }
  file {'/etc/systemd/system/minecraft.service':
    ensure => file,
    source => 'puppet:///modules/minecraft/minecraft.service' # the 3 slashes mean Puppet will pick up the default fileshare at the beginning
  }
  # Set the service to start a boot
  service {'minecraft':
    ensure => running,
    enable => true,
  }
}

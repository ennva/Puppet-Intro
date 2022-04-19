# In init.pp the name of the clas should be the same as the module.Here minecraft
# In a  complex module, is good to define the order way things happen. Ex: Service need to be run after directory is created and java is installed
class minecraft {
  $url = 'https://launcher.mojang.com/mc/game/1.12.2/server/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar'
  $install_dir = '/opt/minecraft'
  file {$install_dir:
    ensure => directory,
  }
  file {"${install_dir}/server.jar":
    ensure => file,
    source => $url, 
    before => Service['minecraft'], #This jar need to be download before a service should run
  }
  package {'java':
    ensure => present,
  }
  file {"${install_dir}/eula.txt":
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
    #This service to run require 3 things(java, eula.txt to be set and a daemon service to be created)
    require => [Package['java'],File["${install_dir}/eula.txt"],File['/etc/systemd/system/minecraft.service']],
  }
}

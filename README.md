## PUPPET

### TOOLS
* Download and install Vagrant (https://www.vagrantup.com/) 
* Download and install VirtualBox
	
### INSTALLATION
* After installing vagrant, run vagrant command "vagrant up" in the same directory than varangfile
* run `vagrant ssh`
* switch to super user: run `sudo su -`
* setup puppet repository: `rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm`
* install packages: `yum install puppetserver vim git`
* set config for memory: vim /etc/sysconfig/puppetserver, JAVA_ARGS 512m, 512m
* start puppet server: `systemctl start puppetserver`
* check server status: `systemctl status puppetserver`
* Enable the server to satrt by default: `systemstl enable puppetserver`
* Inform puppet agent running in the server which puppet server to point to, so edit /etc/pupputlabs/puppet/puppet.config
```
  [agent]
  server = master.puppet.vm
```
* install rubby gem. Use one install with puppet server.Edit your .bash_profile and addfollowing  line:
`
PATH=$PATH:/opt/puppetlabs/puppet/bin
`
* run exec bash
* run source .bash_profile
* test gem command: run gem.
* install gem r10k:gem install r10k.  r10k isa library to deploy puppet code from github unto your server.
* run puppet on the system: `puppet agent -t`

### Set up acontrol repository
* Create a repo in Githup (this repo)
* As a root user create a dir `mkdir /etc/puppetlabs/r10k`
* Create a yaml file `vim /etc/puppetlabs/r10k/r10k.yaml`
* run r10k command to deploy puppet code: `r10k deploy environment -p`. The -p flag tells r10k to download and deploy any external code modules defined in the Puppetfile, but we haven't set that up yet
* Check your environment `cd /etc/puppetlabs/code/environment`. You will see a directory with the name of your branch


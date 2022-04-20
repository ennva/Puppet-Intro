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

### Set up a control repository
* Create a repo in Githup (this repo)
* As a root user create a dir `mkdir /etc/puppetlabs/r10k`
* Create a yaml file `vim /etc/puppetlabs/r10k/r10k.yaml`
* run r10k command to deploy puppet code: `r10k deploy environment -p`. The -p flag tells r10k to download and deploy any external code modules defined in the Puppetfile, but we haven't set that up yet
* Check your environment `cd /etc/puppetlabs/code/environment`. You will see a directory with the name of your branch

### Manage a file (a resource type in puppet)
* define a resource in the file site.pp (look at documentation)[https://puppet.com/docs/puppet/latest/type.html]
* run `r10k deploy environment -p` as sudo in your VM created early with vagrant+virtualbox
* run the puppet agent command `puppet agent -t`

### Classes in puppet (a way to include a set of resources by name)
* (look at the documentation)[https://puppet.com/docs/puppet/latest/lang_classes.html]

### puppetforge (catalogue of puppet modules(puppet packages) created by Puppet,partners and community)
* (look at the platform)[https://forge.puppet.com/]

### Editing Puppetfile (ex: for nginx module)
* Create a file with name `Puppetfile`
* Add the module and its dependencies you want to use from puppetforge

### Puppet Roles and Profiles (best practice for keeping Puppet code organized)
* Profiles: building blocks of your configuration; Wrapper for the subset of configuration; Shold be limited for a single unit of a configuration
* Roles: define the business of the machine. There should be only one role per machine and roles should be made up only of profiles. A role should answer one question "what's this?" with the possible answer "that's a developer's work station","That's a production App server".

### manage more nodes
* Use of dockeragent's puppet module (look at https://forge.puppet.com/modules/samuelson/dockeragent for education purpose)
* Add in your Puppetfile `mod puppetlabs/docker`

### Connect agent nodes to the master
* Login into docker web server node via bash. run `docker exec -it web.puppet.vm bash`
* run puppet agent inside the node. run `puppet agent -t`. By running this command you request a certificate to the master
* As traffic between master/agent-node is encrypted you need to set a certificate into master in order to connect to every node.
* exit on agent-node and on master list all the certificate available: run `puppetserver ca list`.
* set the certificate available: `puppetserver ca sign --certname web.puppet.vm`
* if all agent-node have already requested certificate to the master you can run `puppetserver ca sign --all` to install all the cerficates

### Orchestration in Puppet
* Use of tool <b>MCollective(Marionette Collective)</b>: trigger actions on nodes. Operate on publish-subscribe module: single server(master) maintain the queue suach as ActiveMQ or RabbitMQ and other nodes publish/subscribe to the queue server. Downside:impossible to ensure that the machine has actually received the message
* <b>Ansible or SSH in a for loop</b>: Ansible overlaps with Puppet functionality. it is agentless, you just need SSh access to manage your node. But Ansible doesn't manage desired state. So many combine both tools to manage their infrastructure: Ansible for orchestration and procedural tasks and Puppet for maintaining desired state.
* Puppet <b>Bolt</b> is a newest orchestration option for Puppet. It's agent-less using SSH on the backend.

### What happens when Puppet runs ?
* When agent run, first triggers a program called <b>facter</b> to collect detail about the system
* The agent submit this information to the master
* The master take that information and use it to look up what code is relevant to that machine
* Then the master use those details to compile what's called a catalog
* The catalog doesn't contain any puppet code but is a representation of what specifically needs to happen on that node and in what order. the catalog isn't meant to be human readable but it's in a form that the Puppet agent can understand
* The Master reponds to the agent's initial request with the catalog
* Now the agent takes that catalog and enforces the changes on the node. For example, installing a software package and configuring a user.
* Finally, the agent generates a report of the Puppet run and submit it to the master. These reports contain metadata about the node, its environment in the Puppet version and the catalog used in the run, the status of every resource, actions that puppet took  during the run also called events, logs that been generated during the run, metrics about the run such as duration and hpw many resources were in a given state. With Puppet enterprise, the reports will show up in the wen console. If you use Opensource, you will need to configure an external report processor to take advantage of these reports

### Puppet facter
* tool use by Puppet to get facts about your node in order to figure out what need to be done on that node
* standalone tool. can be use in another tool
* facter command can be run where Puppet is installed (master or agent-node) because it's bundled with Puppet: `facter`, `facter timezone`, `factor fqdn`
 
### Installing SSH and Adding hosts
* generate ssh key in you master node with `ssh-keygen`
* create a profile with ssh key generated defined in ssh_authorized_key
```
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
    user   => 'root',
    type   => 'ssh-rsa',
    key    => 'your key here withour space',
  }
}
```
* deploy your code: `r10k deploy environment -p` and run puppet agent `puppet agent -t` both in master-node and agents-node.
* When ssh is installed you can directly access you agent-node with a simple `ssh <name of your agent-node>` ex: `ssh web.puppet.vm`

### Puppet Module (Set of directories that follow a certain pattern)
* Manifests directory (<b>/manifests</b>): where puppet code is put
	- One class per manifest
	- class's name need to follow a specific naming convention. For the main class in the module, a class should have a same name as the module itself and should be <b><i>manifest/init.pp</i></b>, For example: the nginx class in the nginx module is the manifests/init.pp
* Files directory (<b>/files</b>): contain any static files such as configuration files that you use inside your module. Should be shoter file, large file need to be download externally
* templates directory (<b>/templates</b>): where the dinamic template go. Template allow you to do think like create config files based on the parameters provided to the module. The master can use for example the fact about FQDN send by the agent to include it in the config file.
* lib directory (<b>/lib</b>): where to add additional code to extend the functionality of Puppet
* task directory (<b>/task</b>): where a module author can provide ad-hoc tasks related to their application. These are executed by Puppet bolt or by Puppet Enterprice orchestration tools. The <i>puppetlabs/apt</i> module is an example of one that has tasks (install/update package in linux system without trigger a full puppet installed)
* Others Directories: (<b>/examples</b>), (<b>/spec</b>)
* In the root of module there should be a file called <b>metadata.json</b> to fill in the details of the module
* Every module should include <b>README.md</b> for the documentation about the module
* <b>PDK - Puppet development Kit</b> (https://githup.com/puppetlabs/pdk) is a toolkit made available by Puppet to develop your own module

### Learn Puppet
* learn.puppet.com
 - Learnng VM
 - Instructor-lead training
* docs.puppet.com
* ask.puppet.com



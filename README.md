# vagrant-lab-infrastructure
This repo contains the Vagrantfile and link to any relevant repositories - notably
* https://github.com/lugorguk/ansible-playbook
* https://github.com/lugorguk/common

## How to use this playbook?

* Install [vagrant from https://vagrantup.com](https://vagrantup.com)
* Install [Virtualbox from https://virtualbox.org](https://virtualbox.org)
* Clone the repository `git clone --recursive https://github.com/lugorguk/vagrant-lab-infrastructure` and change into the vagrant-lab-infrastructure directory that has been created.
* then EITHER
  * Enter the playbook "shared secret" by creating a file called vault-password containing that secret in the ansible folder (if you are one of the lug.org.uk admins)
  * OR Create new files in `/ansible/group_vars/all` called 
    * `admins.vault.yml` based on `admins.vault.example`
    * `service.vault.yml` based on `service.vault.example`
    * `lugs.vault.yml` based on `lugs.vault.example` (this may become unencrypted at some point in the future, to permit PRs to get LUGs created on the system.)
* then run it with `vagrant up`

Once you have finished with the environment, run `vagrant destroy` to clean it completely or `vagrant halt` to stop it. If you have made changes you want to test, without destroying and re-building the VMs, run `vagrant provision`

-----

Any issues, please raise an issue on the relevant project:
* https://github.com/lugorguk/vagrant-lab-infrastructure : This project, related specifically to the Vagrantfile
* https://github.com/lugorguk/ansible-playbook : The ansible playbook which will be deployed by the Vagrantfile
* https://github.com/lugorguk/common : Common activities performed on all the lug.org.uk servers

This is the code which will drive lug.org.uk. It was created by Jon "The Nice Guy" Spriggs (jon@sprig.gs | https://jon.sprig.gs | https://twitter.com/jontheniceguy)

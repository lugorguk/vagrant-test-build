Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"
  config.vm.boot_timeout = 0

  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 1536 # 1.5Gb
  end

  config.vagrant.plugins = [ "vagrant-cachier" ]

  config.cache.scope = :box
  config.cache.enable :apt
  config.cache.enable :apt_lists
  config.cache.enable :generic, {
    "vagrant_pip" => {
      cache_dir: "/home/vagrant/.cache/pip"
    },
    "root_pip" => {
      cache_dir: "/root/.cache/pip"
    },
  }

  config.vm.provision "shell",
    inline:  "if [ ! -e /root/.ssh ]
              then
                mkdir /root/.ssh
                cp -Rf /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
                chmod 600 /root/.ssh/authorized_keys
                chmod 700 /root/.ssh
                chown -R root:root /root/.ssh
              fi
             "

  config.vm.define :admin do |admin|
    admin.vm.hostname = "admin.lug.org.uk"
    admin.vm.network "private_network", ip: "203.0.113.10" # RFC5737 Test Network 3
    admin.vm.provider "virtualbox" do |v|
      v.name = "admin"
    end

    admin.vm.provision "shell", 
      inline:  "#!/bin/bash
                if [ -z \"$(command -v ansible)\" ]
                then
                  if [ -z \"$(command -v pip3)\" ]
                  then
                    apt update
                    apt install -y python3-pip curl
                  fi
                  if [ -e /vagrant/Ansible/requirements.txt ]
                  then
                    pip3 install --upgrade -r /vagrant/Ansible/requirements.txt
                  else
                    pip3 install --upgrade ansible
                  fi
                fi
                AnsibleVersion=\"$(pip3 freeze 2>/dev/null | grep ansible-base= | cut -d= -f3)\"

                mkdir -p /etc/ansible/keys
                chmod 755 /etc/ansible
                find /vagrant/.vagrant/machines -type f -name private_key -exec bash /vagrant/populate_machine_keys '{}' /etc/ansible/keys \\;
                chown -R vagrant:vagrant /etc/ansible/keys
                chmod 600 /etc/ansible/keys/*
                chmod 700 /etc/ansible/keys

                if [ ! -e /etc/ansible/ansible.cfg ]
                then
                  wget -q \"https://raw.githubusercontent.com/ansible/ansible/v${AnsibleVersion}/examples/ansible.cfg\" -O /etc/ansible/ansible.cfg
                  chmod 644 /etc/ansible/ansible.cfg
                  ansible localhost -m lineinfile -a \"regexp='^#?host_key_checking.*' line='host_key_checking = False' path=/etc/ansible/ansible.cfg\"
                  ansible localhost -m lineinfile -a \"regexp='^#?ssh_args.*' line='ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes' path=/etc/ansible/ansible.cfg\"
                fi
                if [ ! -e /etc/ansible/hosts ]
                then
                  echo 'admin ansible_connection=local' > /etc/ansible/hosts
                  # echo 'SOME_HOST ansible_host=192.0.2.1 ansible_user=root' >> /etc/ansible/hosts
                  chmod 644 /etc/ansible/hosts
                fi
                chown -R root:vagrant /etc/ansible
                if [ -z \"$(command -v bindfs)\" ]
                then
                  apt update
                  apt install -y bindfs
                fi
                mkdir -p /etc/ansible/install
                if [ ! -e '/etc/systemd/system/etc-ansible-install.mount' ]
                then
                  {
                    echo '[Unit]'
                    echo 'Description=BindFS Mount of /vagrant/Ansible to /etc/ansible/install'
                    echo ''
                    echo '[Mount]'
                    echo 'What=/vagrant/Ansible'
                    echo 'Where=/etc/ansible/install'
                    echo 'Type=fuse.bindfs'
                    echo 'Options=mirror=root:vagrant,perms=0640:ugd+x'
                    echo ''
                    echo '[Install]'
                    echo 'WantedBy=multi-user.target'
                  } > /etc/systemd/system/etc-ansible-install.mount
                fi
                systemctl enable --now etc-ansible-install.mount"

    admin.vm.provision "ansible_local", run: "always" do |ansible|
      ansible.playbook            = "/etc/ansible/install/site.yml"
      ansible.limit               = "all"
      ansible.playbook_command    = "/usr/bin/sudo /usr/local/bin/ansible-playbook"
      ansible.vault_password_file = "/etc/ansible/install/vaultpw"
      ansible.inventory_path      = "/etc/ansible/hosts"
    end
  end
end

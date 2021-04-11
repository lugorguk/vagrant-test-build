# Based on https://vtorosyan.github.io/ansible-docker-vagrant/
# and https://github.com/AkihiroSuda/containerized-systemd/
# and https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
# with tweaks indicated by https://github.com/containers/podman/issues/3295
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.build_dir       = "."
    d.has_ssh         = true
    d.remains_running = false
    d.create_args     = ['--tmpfs', '/tmp', '--tmpfs', '/run', '--tmpfs', '/run/lock', '-v', '/sys/fs/cgroup:/sys/fs/cgroup:ro', '-t']
  end

  config.vm.define "mailman" do |mailman|
    mailman.vm.hostname = "mailman.lug.org.uk"
    mailman.vm.network "private_network", ip: "2001:ba8:1f1:f090::2"
    mailman.vm.provider "docker" do |d|
      d.name = "mailman_lug_org_uk"
    end
  end

  config.vm.define "mail-in-01" do |mailin01|
    mailin01.vm.hostname = "mail-in-01.lug.org.uk"
    mailin01.vm.network "private_network", ip: "2001:ba8:1f1:f08d::2"
    mailin01.vm.provider "docker" do |d|
      d.name = "mailin01_lug_org_uk"
    end
  end

  config.vm.define "snm" do |snm|
    snm.vm.hostname = "snm.lug.org.uk"
    snm.vm.network "private_network", ip: "2001:ba8:1f1:f075::2"
    snm.vm.provider "docker" do |d|
      d.name = "snm_lug_org_uk"
    end
  end

  config.vm.define "web-01" do |web01|
    web01.vm.hostname = "web-01.lug.org.uk"
    web01.vm.network "private_network", ip: "2001:ba8:1f1:f091::2"
    web01.vm.provider "docker" do |d|
      d.name = "web01_lug_org_uk"
    end
  end

  config.vm.define "admin" do |admin|
    admin.vm.hostname = "admin.lug.org.uk"
    admin.vm.network "private_network", ip: "2001:ba8:1f1:f08c::2"
    admin.vm.provider "docker" do |d|
      d.name = "admin_lug_org_uk"
    end

    admin.vm.provision "ansible_local", run: "always" do |ansible|
      ansible.playbook         = "build_setup.yml"
      ansible.playbook_command = "sudo ansible-playbook"
      ansible.install_mode     = "pip"
      ansible.pip_install_cmd  = "sudo apt install -y python3-pip && sudo rm -f /usr/bin/pip && sudo ln -s /usr/bin/pip3 /usr/bin/pip"
    end
  end

end

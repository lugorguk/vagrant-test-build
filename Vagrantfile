Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.vm.boot_timeout = 0

  # Enable caching
  # Install with
  #   vagrant plugin install vagrant-cachier

  # Enable hostfile management
  # Install with
  #   vagrant plugin install vagrant-hostmanager
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = false
  end

  config.vm.box_check_update = false

  # lug.org.uk IP addressing for dev only - replace 192.0.2.xxx/24 with actual IPs if you want to replicate Live.

  config.vm.define :admin do |admin|
    admin.vm.hostname = "admin.lug.org.uk"
    admin.vm.network "private_network", ip: "192.0.2.199"
    if Vagrant.has_plugin?("vagrant-hostmanager")
      admin.hostmanager.aliases = %w(admin lugadmin.lug.org.uk lugadmin lugadmin.dnuk.lug.org.uk ns1.lug.org.uk rt.lug.org.uk)
    end

    admin.vm.provision "ansible_local" do |ansible|
      ansible.playbook            = "ansible/site.yml"
      ansible.install_mode        = :pip
      ansible.limit               = "admin.lug.org.uk"
      ansible.inventory_path      = "ansible/hosts.lab"
      ansible.vault_password_file = "ansible/vault-password"
      ansible.extra_vars          = {lab: true}
      if ENV['ansible_verbose'] != ''
        ansible.verbose           = ENV['ansible_verbose']
      end
      if ENV['ansible_tags'] != ''
        ansible.tags              = ENV['ansible_tags']
      end
      if ENV['ansible_skip'] != ''
        ansible.skip_tags         = ENV['ansible_skip']
      end
    end
  end

#  config.vm.define :web01 do |web01|
#    web01.vm.hostname = "web-01.lug.org.uk"
#    web01.vm.network "private_network", ip: "192.0.2.200"
#    if Vagrant.has_plugin?("vagrant-hostmanager")
#      web01.hostmanager.aliases = %w(web-01 xinit.lug.org.uk mail.lug.org.uk aberdeen.lug.org.uk accrington.lug.org.uk allug.lug.org.uk autistic.lug.org.uk aylesbury.lug.org.uk basset.lug.org.uk belfast.lug.org.uk beverley.lug.org.uk bhc.lug.org.uk blackburn.lug.org.uk blackpool.lug.org.uk blug.lug.org.uk chester.lug.org.uk ci.lug.org.uk cleveland.lug.org.uk coventry.lug.org.uk deaf.lug.org.uk derry.lug.org.uk doncaster.lug.org.uk dundee.lug.org.uk ear.lug.org.uk eastlondon.lug.org.uk edinburgh.lug.org.uk essex.lug.org.uk euslug.lug.org.uk exeslug.lug.org.uk eyorks.lug.org.uk falkirk.lug.org.uk fod.lug.org.uk fuengirola.lug.org.uk gla.lug.org.uk glastonbury.lug.org.uk highland.lug.org.uk hud.lug.org.uk hudlug.lug.org.uk hull.lug.org.uk inverness.lug.org.uk iow.lug.org.uk jsuc.lug.org.uk kent.lug.org.uk lancaster.lug.org.uk leamington.lug.org.uk leicester.lug.org.uk lgbt.lug.org.uk lincs.lug.org.uk littlehampton.lug.org.uk ljmu.lug.org.uk lse.lug.org.uk lust.lug.org.uk mansfield.lug.org.uk map.lug.org.uk menai.lug.org.uk merseyside.lug.org.uk mgeeks.lug.org.uk moray.lug.org.uk nderbys.lug.org.uk nelug.lug.org.uk new.lug.org.uk newlinc.lug.org.uk north-wales.lug.org.uk northlondon.lug.org.uk northsom.lug.org.uk northwales.lug.org.uk northwestlondon.lug.org.uk nuke.lug.org.uk nuneaton.lug.org.uk obaoss.lug.org.uk ormskirk.lug.org.uk orpington.lug.org.uk ox.lug.org.uk oxford.lug.org.uk peterboro.lug.org.uk peterborough.lug.org.uk plymouth.lug.org.uk powys.lug.org.uk preston.lug.org.uk rhonddacynontaff.lug.org.uk rustington.lug.org.uk schools.lug.org.uk scotborders.lug.org.uk sderby.lug.org.uk shetland.lug.org.uk shropshire.lug.org.uk sl.lug.org.uk sluguk.lug.org.uk southwales.lug.org.uk ssom.lug.org.uk staffs.lug.org.uk students.lug.org.uk sussex.lug.org.uk swindon.lug.org.uk thanet.lug.org.uk trlinux.lug.org.uk tslug.lug.org.uk watford.lug.org.uk west-wales.lug.org.uk westberkshire.lug.org.uk westlothian.lug.org.uk westwales.lug.org.uk wishlug.lug.org.uk wlv.lug.org.uk wolves.lug.org.uk wos.lug.org.uk wot.lug.org.uk yopy.lug.org.uk young.lug.org.uk)
#    end
#  end

#  config.vm.define :mailin01 do |mailin01|
#    mailin01.vm.hostname = "mail-in-01.lug.org.uk"
#    mailin01.vm.network "private_network", ip: "192.0.2.201"
#    if Vagrant.has_plugin?("vagrant-hostmanager")
#      mailin01.hostmanager.aliases = %w(mail-in-01)
#    end
#  end

#  config.vm.define :snm do |snm|
#    snm.vm.hostname = "snm.lug.org.uk"
#    snm.vm.network "private_network", ip: "192.0.2.202"
#    if Vagrant.has_plugin?("vagrant-hostmanager")
#      snm.hostmanager.aliases = %w(snm armedforces.lug.org.uk ayrshire.lug.org.uk b-b.lug.org.uk beds.lug.org.uk bradford.lug.org.uk bristol.lug.org.uk chelmer.lug.org.uk dorset.lug.org.uk gllug.lug.org.uk herts.lug.org.uk iom.lug.org.uk leigh.lug.org.uk lincoln.lug.org.uk liv.lug.org.uk mk.lug.org.uk northants.lug.org.uk portsmouth.lug.org.uk rugby.lug.org.uk runcornwidnes.lug.org.uk ryedale.lug.org.uk southsea.lug.org.uk southwest.lug.org.uk standrews.lug.org.uk wiltshire.lug.org.uk wirral.lug.org.uk)
#    end
#  end

#  config.vm.define :mailman do |mailman|
#    mailman.vm.hostname = "mailman.lug.org.uk"
#    mailman.vm.network "private_network", ip: "192.0.2.203"
#    if Vagrant.has_plugin?("vagrant-hostmanager")
#      mailman.hostmanager.aliases = %w(mailman lists.lug.org.uk)
#    end
#  end

end

# Based on https://vtorosyan.github.io/ansible-docker-vagrant/
# and https://github.com/AkihiroSuda/containerized-systemd/

FROM debian:buster AS debian_with_systemd

# This stuff enables SystemD on Debian based systems
STOPSIGNAL SIGRTMIN+3
RUN DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends systemd systemd-sysv dbus dbus-user-session
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "/bin/bash" ]

# This part enables an SSH Server (required for Vagrant)
RUN DEBIAN_FRONTEND=noninteractive apt install -y sudo openssh-server
RUN mkdir /var/run/sshd
#    We enable SSH here, but don't start it with "now" as the build stage doesn't run anything long-lived.
RUN systemctl enable ssh
EXPOSE 22

# This part creates the vagrant user, sets the password to "vagrant", adds the insecure key and sets up password-less sudo.
RUN useradd -G sudo -m -U -s /bin/bash vagrant
#    chpasswd takes a colon delimited list of username/password pairs.
RUN echo 'vagrant:vagrant' | chpasswd
RUN mkdir -m 700 /home/vagrant/.ssh
# This key from https://github.com/hashicorp/vagrant/tree/main/keys. It will be replaced on first run.
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant
RUN echo 'vagrant ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

FROM debian_with_systemd AS debian_with_systemd_and_ansible
RUN apt install -y gnupg2 lsb-release software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN add-apt-repository -u -y "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main"
RUN apt install -y ansible
# Yes, I know. Trusty? On Debian Buster?? But, that's what the Ansible Docs say!
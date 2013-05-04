#!/usr/bin/env bash

### Remote Pairing Machine bootstrap
###
### This script should be run as root, preferably by cloud-init:
###
###   ec2-run-instances --key $EC2_KEY -t m1.small -f <this script> <IMAGE>

set -ev

log() {
    echo $1 | tee -a /var/log/bootstrap_out.log
}

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

log 'Updating packages'
# Add multiverse repositories (for EC2 tools)
sed -r -i 's/universe/universe multiverse/g' /etc/apt/sources.list
apt-get update

log 'Installing postgresql'
apt-get install -y postgresql postgresql-client libpq-dev

sudo -u postgres createuser -s jgdavey

log 'Installing make and friends'
apt-get install -y autoconf make automake pkg-config

log 'Installing Ruby and Rails required libs'
apt-get install -y libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libgdbm-dev libncurses5-dev libtool bison libffi-dev node

log 'Installing source control (git)'
apt-get install -y git-core exuberant-ctags

log 'Installing zsh'
apt-get install -y zsh

log 'Installing tmux'
apt-get build-dep -y tmux
(
    cd /tmp
    git clone https://github.com/ThomasAdam/tmux.git
    cd tmux
    git checkout 1.8
    ./autogen.sh
    ./configure
    make
    make install
) > /var/log/tmux_build.log

log 'Installing Ruby 1.8'
apt-get install -y ruby-full

log 'Creating user account(s)'
useradd jgdavey -m -s /bin/zsh -G sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,admin

homefolder="/home/jgdavey"


keyfile="$homefolder/.ssh/authorized_keys"
sudo -u jgdavey mkdir -p "$homefolder/.ssh"
touch $keyfile
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq9DAjwtVOrVBR132SV2AwMkqqOODUzDu1LgIZ/WSQsZ+CE0gWCHVWYqy5xTAeWRvHBvNWL7Vkjpt4zqZi2MBKi0c+9//8S/Wu245OCRy5K3V/p6Qs6jEvDFG5DILra69EideBICDq0VPlYJo0X30L5KL3pXYWmEdA0njnpEFH7rpaJZEjdbe/O0sVwvSmqtWyBPwZ65+LKbS4C4ydGjWUTNgp9HsNqiMVZ06jKXj2rlOdjroiJEnEwHIJYKuXjdb8/waUtBXHcFB/GUSjsbSygrs3t/q1MaWOJ071xD7C51o32bCOsdnJjOzX3+G5vfnVkHLB3vDOGDb44Sc5sFRTQ== jgdavey@rupert.local' >> $keyfile
chown jgdavey:jgdavey $keyfile
sudo -u jgdavey chmod 600 $keyfile

# Rubygems
if ! [ -e /usr/bin/gem ]; then
    log 'Installing rubygems'
    (
        cd /tmp
        wget http://production.cf.rubygems.org/rubygems/rubygems-1.5.2.tgz
        tar xzf rubygems-1.5.2.tgz
        cd rubygems-1.5.2
        sudo ruby setup.rb
        cd /usr/bin
        sudo ln -s gem1.8 gem
    )
fi

# RVM
log 'Setting up RVM for user jgdavey'
cd /tmp
curl -L https://get.rvm.io | sudo -i -u jgdavey bash -s stable

# Login message
cat <<'EOF' > /tmp/motd

    OMG, hi there!!1! This machine should be all set for a great pairing
    session. Don't forget to terminate this instance when you're done.

    Have fun! <3 <3 <3

EOF

mv /tmp/motd /etc/

# Enable password-less `sudo` for the users in the "sudo" group:
cat <<'EOF' > /tmp/new_sudoers

# Enable password-less sudo for all users in the "sudo" group
%sudo ALL=NOPASSWD: ALL

EOF
sh -c 'cat /tmp/new_sudoers >> /etc/sudoers'

log ' '
log '#### DONE ####

# vi: ft=sh
#! /bin/bash  -xue

test  -f "/root/.provision/docker"  &&  exit 0

# Docker
cat  << __EOF__  |  sudo  tee  /etc/docker/daemon.json
{
    "data-root" : "/ext-hdd/data/docker"
}
__EOF__

ps  aux  | grep  docker
rsync  -av  /var/lib/docker/  /ext-hdd/data/docker/
mv  /var/lib/docker  /var/lib/docker.org
ln  -s   /ext-hdd/data/docker  /var/lib/docker
rm  -rf  /var/lib/docker.org

sudo  systemctl  restart  docker

sudo  chmod  1777  /ext-hdd/data
sudo  gpasswd  -a  vagrant  docker

mkdir -p "/root/.provision"
date  >  "/root/.provision/docker"

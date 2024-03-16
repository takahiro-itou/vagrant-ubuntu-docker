#! /bin/bash  -xue

test  -f /root/.provision.root  &&  exit 0

echo  Provisioning $HOSTNAME

sudo  timedatectl  set-timezone Asia/Tokyo

# New HDD (/dev/sdc)
cat <<  __EOF__  |  tee  /dev/shm/zero.md5
53e979547d8c2ea86560ac45de08ae25 *-
__EOF__

if sudo dd if=/dev/sdd  bs=512 count=3 | md5sum -c /dev/shm/zero.md5 ; then
    echo "Disk Not Formatted."  1>&2

    sudo  parted --script --align optimal /dev/sdc -- mklabel gpt
    sudo  parted --script --align optimal /dev/sdc -- mkpart primary ext3 1 -1
    sudo  mkfs.ext3 /dev/sdc1
else
    echo "Disk Already Formated."   1>&2
    sleep  5
fi

sudo  dd if=/dev/sdd  bs=512 count=3 | md5sum -b

sudo  mkdir  -p    /ext-hdd/data
sudo  chmod  1777  /ext-hdd/data

echo  -e  "/dev/sdc1\t/ext-hdd/data\text3\tdefaults\t0\t0"  \
    |  sudo  tee -a  /etc/fstab

# RamDisk
sudo  mkdir        /ramdisk
sudo  chmod  1777  /ramdisk
echo  -e  "tmpfs\t/ramdisk\ttmpfs\trw,size=2048m,x-gvfs-show\t0\t0"  \
    |  sudo  tee -a  /etc/fstab

sudo  mount  -a

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

date  >  /root/.provision.root

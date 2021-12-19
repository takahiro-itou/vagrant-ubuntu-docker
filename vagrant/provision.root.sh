#! /bin/bash  -xue

test  -f /root/.provision.root  &&  exit 0

echo  Provisioning $HOSTNAME

sudo  timedatectl  set-timezone Asia/Tokyo

# New HDD (/dev/sdc)
sudo  parted  --script --align optimal  /dev/sdc -- mklabel gpt
sudo  parted  --script --align optimal  /dev/sdc -- mkpart primary ext3 1 -1

# RamDisk
sudo  mkdir        /ramdisk
sudo  chmod  1777  /ramdisk
echo  -e  "tmpfs\t/ramdisk\ttmpfs\trw,size=2048m,x-gvfs-show\t0\t0"  \
      |  sudo  tee -a  /etc/fstab
sudo  mount  -a

date  >  /root/.provision.root

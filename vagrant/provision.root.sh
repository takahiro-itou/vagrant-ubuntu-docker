#! /bin/bash  -xue

test  -f /root/.provision.root  &&  exit 0

echo  Provisioning $HOSTNAME

sudo  timedatectl  set-timezone Asia/Tokyo
sudo  timedatectl  set-ntp  true
sudo  systemctl restart systemd-timesyncd.service
sleep 4
systemctl status  systemd-timesyncd.service
sleep 4


# New HDD (/dev/sdc)
cat <<  __EOF__  |  tee  /dev/shm/zero.md5
53e979547d8c2ea86560ac45de08ae25 *-
__EOF__

cat <<  __EOF__  |  tee  /dev/shm/check_mbr.md5
0a4dbaf15747a2f282529ebec196a2d4 *-
__EOF__

# MBR/GPT ヘッダ 3 セクタ 768 バイトが全部ゼロなら未初期化と判定
sudo  dd if=/dev/sdc bs=512 count=3 | md5sum -b
if sudo dd if=/dev/sdc bs=512 count=3 | md5sum -c /dev/shm/zero.md5 ; then
    sudo  parted --script --align optimal /dev/sdc -- mklabel gpt
    sudo  parted --script --align optimal /dev/sdc -- mkpart primary ext3 1 -1
    sudo  mkfs.ext3     /dev/sdc1
else
    echo "Disk Already Formatted."  1>&2
    sleep  5
fi

# GPT ヘッダは毎回変わるようなので、MBR ヘッダだけ確認する
sudo  dd if=/dev/sdc bs=512 count=1 | md5sum -b
sudo  dd if=/dev/sdc bs=512 count=1 | md5sum -c /dev/shm/check_mbr.md5

sudo  mkdir  -p    /ext-hdd/data
sudo  chmod  1777  /ext-hdd/data
ls -al /ext-hdd/
sleep 5

echo  -e  "/dev/sdc1\t/ext-hdd/data\text3\tdefaults\t0\t0"  \
    |  sudo  tee -a  /etc/fstab
ls -al /ext-hdd/
sleep 5

# RamDisk
sudo  mkdir        /ramdisk
sudo  chmod  1777  /ramdisk
echo  -e  "tmpfs\t/ramdisk\ttmpfs\trw,size=2048m,x-gvfs-show\t0\t0"  \
    |  sudo  tee -a  /etc/fstab

ls -al /ext-hdd/
sleep 5

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

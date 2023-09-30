```shell
sudo apt-get install samba samba-common smbclient
sudo cp /etc/samba/smb.conf  /etc/samba/smb.conf.bak
sudo vim /etc/samba/smb.conf
```
```shell
[home]
comment = home
browseable = yes
path = /mnt/wd4t/
create mask = 0777
directory mask = 0777
valid users = shafish
force user = nobody
force group = nogroup
public = yes
writable = yes
available = yes
```
```shell
sudo smbpasswd -a shafish
sudo service smbd restart
smbclient -L //192.168.0.100/home
smbclient -L //192.168.0.100/home -U%
```
`sudo mkdir /mnt/wd4t`
`sudo mount -t cifs //192.168.0.100/home /mnt/wd4t -o username=shafish`

/mnt/hgst/
/mnt/wd/
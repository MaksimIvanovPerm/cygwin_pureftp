# cygwin_pureftp
stuff for pure-ftp in cygwin
ftpservice.sh: bash-script for starting|stopping and asking status - if pure-ftpd is running or not;

notes about preparationing and launching pure-ftp on cygwin
#https://gathering.tweakers.net/forum/list_messages/887361
#https://download.pureftpd.org/pub/pure-ftpd/doc/README.Windows
mkdir /home/ftpuser
user_name="ftpuser"
user_pwd="..."
user_uid=`id -u $USER`
user_gid=`id -g $USER`
# pure-pw userdel ftpuser -f /etc/pureftpd.passwd -m
PURE_PASSWDFILE="/etc/pureftpd.passwd"
PURE_DBFILE="/etc/pureftpd.pdb"
echo -e "$user_pwd\n$user_pwd\n" | pure-pw useradd $user_name -d /home/ftpuser -u $user_uid -g $user_gid -m
pure-pw show $user_name
pure-pw usermod $user_name -d /cygdrive/c/Temp/downloads -m
echo -e "$user_pwd\n$user_pwd\n" | pure-pw passwd $user_name -m

pure-ftpd --bind localhost,3131 -4 -H -E -B -d -O stats:/cygdrive/c/Temp/pure_ftpd.log -l puredb:/etc/pureftpd.pdb
echo "new pure-ftpd instance is: `cat /var/run/pure-ftpd.pid`"

watch -d -n 2 pure-ftpwho.exe -n -v


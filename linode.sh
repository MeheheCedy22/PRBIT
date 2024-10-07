sudo apt update && sudo apt upgrade -y
sudo apt update && sudo apt install neofetch net-tools -y
sudo reboot

echo 'alias cls="clear"' >> ~/.bashrc
echo 'alias lss="ls -alh1 --group-directories-first"' >> ~/.bashrc
source ~/.bashrc

sudo useradd -m -s /bin/bash --group sudo prbit
sudo usermod -aG sudo prbit
passwd prbit

mkdir /home/prbit/.ssh
touch /home/prbit/.ssh/authorized_keys
cat ~/.ssh/authorized_keys > /home/prbit/.ssh/authorized_keys


sudo nano /etc/ssh/sshd_config
```
PermitRootLogin yes -> PermitRootLogin no
PasswordAuthentication yes -> PasswordAuthentication no
X11Forwarding yes -> X11Forwarding no
```
# jedno z tohto
sudo systemctl restart ssh
sudo systemctl restart sshd

# potom exit, lognut sa za prbit usera a nasledne zase si dat aliasi do shellu
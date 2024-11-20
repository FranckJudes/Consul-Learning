
################# installation consul  ###########################

apt-get update

apt-get install -y wget unzip dnsutils

wget https://releases.hashicorp.com/consul/1.20.1/consul_1.20.1_linux_386.zip
unzip consul_1.20.1_linux_386.zip
mv consul /usr/local/bin/ 
groupadd --system consul
useradd -s /sbin/nologin --system -g consul consul 
mkdir -p /var/lib/consul 
chown -R consul:consul /var/lib/consul 
chmod -R 775 /var/lib/consul 
mkdir /etc/consul.d 
chown -R consul:consul /etc/consul.d



##################################################################





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



################## fichier de conf ######################################

echo '{ 
  "node_name" : "consul-server" , 
  "server" : true , 
  "bootstrap" : true , 
  "ui_config" : { 
    "enabled" : true 
  } , 
  "datacenter" : "dc1" , 
  "data_dir" : "consul/data" , 
  "log_level" : "INFO" , 
  "addresses" : { 
    "http" : "0.0.0.0" 
  } , 
  "connect" : { 
    "enabled" : true 
  } 
}
' > /etc/consul.d/config.json

######################### service ######################################

echo '[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent \
  -node=serveur-consul \
  -bind=172.17.0.4 \
  -advertise=172.17.0.4 \
  -data-dir=/var/lib/consul \
  -config-dir=/etc/consul.d \
  

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/consul.service







  
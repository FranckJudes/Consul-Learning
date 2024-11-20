
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



############### fichier de conf ###################################

echo '{ 
  "node_name" : "Deposit and Transfert Service" , 
  "server" : false , 
  "datacenter" : "Kairos_datacenter" , 
  "data_dir" : "consul/data" , 
  "log_level" : "INFO" , 
  "retry_join" : [ "172.17.0.2" ] , 
  "service" : { 
    "id" : "dns" , 
    "name" : "Deposit and Transfert Service" , 
    "tags" : [ "primary" ] , 
    "address" : "localhost" , 
    "port" : 8600 , 
    "check" : { 
      "id" : "dns" , 
      "name" : "Deposit and Transfert Service 8600" , 
      "tcp" : "localhost:8600" , 
      "interval" : "10s" , 
      "timeout" : "1s" 
    } 
  } 
}
' >/etc/consul.d/config.json


################## service  ########################################


echo '[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-file=/etc/consul.d/config.json 

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
WantedBy=multi-user.target' >/etc/systemd/system/consul.service


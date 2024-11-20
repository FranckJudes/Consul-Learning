
################# installation consul  ###########################

apt-get update

apt-get install -y wget unzip dnsutils supervisor



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
echo '
  [program:server]
  command=consul agent -config-file=/etc/consul.d/config.json
  autostart=true
  autorestart=true
  stderr_logfile=/var/log/server.err.log
  stdout_logfile=/var/log/server.out.log
' > /etc/supervisor/conf.d/server.conf

service supervisor start
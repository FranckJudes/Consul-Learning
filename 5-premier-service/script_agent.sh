
################# installation consul  ###########################

apt-get update

apt-get install -y wget unzip dnsutils python-flask net-tools supervisor


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
  "node_name" : "consul-client" , 
  "server" : false , 
  "datacenter" : "dc1" , 
  "data_dir" : "consul/data" , 
  "log_level" : "INFO" , 
  "retry_join" : [ "consul-server" ] , 
  "service" : { 
    "id" : "dns" , 
    "name" : "dns" , 
    "tags" : [ "primary" ] , 
    "address" : "localhost" , 
    "port" : 8600 , 
    "check" : { 
      "id" : "dns" , 
      "name" : "Consul DNS TCP sur le port 8600" , 
      "tcp" : "localhost:8600" , 
      "interval" : "10s" , 
      "timeout" : "1s" 
    } 
  } 
}
' >/etc/consul.d/config.json


################## service systemD ########################################


echo '
  [program:client]
  command=consul agent -config-file=/etc/consul.d/config.json
  autostart=true
  autorestart=true
  stderr_logfile=/var/log/client.err.log
  stdout_logfile=/var/log/client.out.log
' > /etc/supervisor/conf.d/client.conf

service supervisor start


####################### mon application ##################################

echo "#!/usr/bin/python
from flask import Flask
import socket
app = Flask(__name__)


@app.route('/')
def hello_world():
    hostname = socket.gethostname()
    message = 'Bonjour, je suis ' + hostname + '\n'
    return message

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
" >/tmp/app.py


####################### service consul ####################################


echo '
{"service":
        {
    "name": "monservice",
    "tags": ["python"],
    "port": 80,
    "check": {
      "http": "http://localhost:5000/",
      "interval": "3s"
    }
  }
}
' > /etc/consul.d/monservice.json

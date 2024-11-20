%title: CONSUL
%author: xavki


# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

Abonnez-vous et soutenez la chaine Xavki !!!

<br>


Objectifs ?

		* enregistrer les services

		* répertorier les instances (pods)

		* fourni un dns

		* possibilité de taguer


---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

0 - installer un serveur consul (cf vidéo précédente)
			* dans ou hors kubernetes

<br>

1 - déploiement de consul-sync avec la chart helm (manuellement possible)
		 consul-sync > syncCatalog
<br>

2 - déployer un deployment et son service avec une annotation

---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

* chart helm

```
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: consul-sync
spec:
  releaseName: consul-sync
  helmVersion: v3
  chart:
    repository: https://helm.releases.hashicorp.com
    name: consul
    version: 0.22.0
  values:
    global:
      enabled: false
      datacenter: mydc
    syncCatalog:
      addK8SNamespaceSuffix: false
      default: true
      enabled: true
      image: 
      syncClusterIPServices: true
      toConsul: true
      toK8S: false
    client:
      enabled: true
      join:
       - 192.168.12.20
```

---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

* création d'un déploiement

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mynginx
spec:
  selector:
    matchLabels:
      app: mynginx
  replicas: 2
  template:
    metadata:
      labels:
        app: mynginx
    spec:
      containers:
      - name: mynginx
        image: nginx
        ports:
        - containerPort: 80
```

---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

* création d'un service

```
apiVersion: v1
kind: Service
metadata:
  name: mynginx
  labels:
    app: mynginx
  annotations:
    "consul.hashicorp.com/service-name": "xavki"
    "consul.hashicorp.com/service-tags": "gui"
    "consul.hashicorp.com/service-sync": "true"
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    app: mynginx
```

---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

* 

```
  'consul.hashicorp.com/service-port': 'http'
  'consul.hashicorp.com/service-tags': 'primary,foo'
  'consul.hashicorp.com/service-meta-KEY': 'value'
  'consul.hashicorp.com/synced': true
```

* Défault label

```
  consul=true
```

---------------------------------------------------------------------------------------

# CONSUL : consul-sync dans votre cluster Kubernetes !!

<br>

* quelques options du catalog

```
syncCatalog:  
  enabled: true  
  default: true
  k8sAllowNamespaces: ['my-ns-1', 'my-ns-2']
  k8sDenyNamespaces: []
  toConsul: false
  toK8S: true
```

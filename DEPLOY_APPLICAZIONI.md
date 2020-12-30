# DEPLOY DELLE APPLICAZIONI

La pipeline cliente presenta un Dockerfile nei repository bitbucket che viene buildata da AWS tramire il servizio CodeBuild.  
I file vengono estratti dal servizio di storage object S3.  

Sotto sono riportati i path e i nomi dei vari file yaml delle applicazioni presenti in S3 da deployare sul cluster EKS:  
- s3://cn-configs-repository/eks/nome-applicazione  
  - deployment.yaml: scarica l'immagine dall'ECR di AWS,  
  - hpa.yaml: horizontal pod authoscaling per scalare i pod delle applicazioni,  
  - service.yaml: esposizione del servizio.  

Un esempio dei tre file yaml è presente in questo repository nella directory "deploy-yaml-applicazione-esempio".  

Parametri d'interesse:  
- deployment.yaml
  - replicas: informazione data dal cliente, per alcune applicazioni può variare,  
  - il nome dell'applicazione: informazione data dal cliente,  
  - il nome del namespace in cui giace l'applicazione: websites per tutte le applicazioni,  
  - IMAGE_PLACEHOLDER: l'image URI facilmente reperibile dal servizio ECR della console AWS con il tag dell'ultima release.  
  Si noti che dopo ogni build applicativo il tag dell'ultima release cambia, quindi assicurarsi sempre di prendere l'URI con il tag più recente.  
  Nota importante: il path /ping nelle sezioni livenessProbe e readinessProbe dev'essere congruo con il path inserito nel repo bitbucket cliente. Se diverso, apportare la modifica nel repository e re-buildare il tutto, con conseguente modifica dell'IMAGE_PLACEHOLDER.  
- service.yaml  
  - il nome dell'applicazione: informazione data dal cliente,  
  - il nome del namespace in cui giace l'applicazione:  websites per tutte le applicazioni.  
- hpa.yaml  
  - minReplicas: deve essere congruente con le replicas del deployment.yaml, non causa errori l'incongruenza, ma è per avere una situazione più corretta possibile,  
  - maxReplicas: informazione data dal cliente, per alcune applicazioni può variare,  
  - il nome dell'applicazione: informazione data dal cliente,  
  - il nome del namespace in cui giace l'applicazione: websites per tutte le applicazioni.  

## Scaricare i file yaml da s3  

Dal container kubectl o dalla macchina da cui ci si connette al cluster EKS scaricare i file da s3:
```
mkdir eks
cd eks/
aws s3 cp --recursive s3://cn-configs-repository/eks/<nome-applicazione> <directory-di-destinazione>
```

Nota: possibile presenza di caratteri spuri, per sicurezza eseguire il comando sotto riportato
```
find . -type f -exec dos2unix {} \;
```

## Applicare i file  
```
kubectl apply -f <directory-di-destinazione>
```

## Importante  
Se si dovessero cambiare i parametri dei file nel repository bitbucket del cliente:  
- rieseguire la build da AWS CodeBuild,  
- sostituire nel deployment.yaml l'immagine nuova creata dell'applicazione (reperibile da ECR e filtrando per il nome dell'applicazione).  

Uscire, stoppare e rimuovere il container una volta concluso il lavoro:  
```
docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
************        ************        "bash"              19 seconds ago      Up 19 seconds                           kubectl

docker stop <CONTAINER ID>
docker rm <CONTAINER ID>
```

Quando non più necessaria, rimuovere l'immagine:  
```
docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
************.dkr.ecr.eu-west-1.amazonaws.com/kubectl   ***********         ***********         X months ago        XXXMB

docker rmi <IMAGE ID>
```

## Connessione all'applicazione deployata

Il tipo di porta utilizzata dalle applicazioni è NodePort.  
Per connettersi a queste si è creato un ingress specificando le regole per la connessione a livello di "host", che deve essere uguale al campo "server_name" del file di configurazione di nginx presente nel repo bitbucket della rispettiva applicazione.  

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: "<nome-ingress-apps>"
  namespace: "<namespace>"
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/success-codes: "200,302,403"
    alb.ingress.kubernetes.io/load-balancer-attributes: idle_timeout.timeout_seconds=120
  labels:
    app: <nome-ingress-apps>
spec:
  rules:
    - host: nome.app-1.it
      http:
         paths:
            - path: /*
              backend:
                serviceName: <nome-service-app-1>
                servicePort: 80
    - host: nome.app-2.it
      http:
         paths:
            - path: /*
              backend:
                serviceName: <nome-service-app-2>
                servicePort: 80

    ...
    
    - host: nome.app-n.it
      http:
         paths:
            - path: /*
              backend:
                serviceName: <nome-service-app-n>
                servicePort: 80
```

Per visualizzare sul nostro PC la pagina dell'applicazione prendiamo l'indirizzo dell'ALB, visibile nella pagina dei Load Balancer nella sezione EC2 della console AWS, riconoscibile dai tag:  
```
ingress.k8s.aws/stack                   <namespace>/<namespace>-alb-ingress
kubernetes.io/ingress-name              <namespace>-alb-ingress
ingress.k8s.aws/cluster                 <eksclustername>
kubernetes.io/cluster/<eksclustername>  owned
ingress.k8s.aws/resource                LoadBalancer
kubernetes.io/namespace                 <namespace>
```

Aggiungiamo pertanto l'indirizzo pubblico del loadbalancer in combinazione con il nome dns dell'applicazione al file hosts del nostro PC (campo "server_name" del file di configurazione di nginx).  
Sotto si è preso come esempio l'IP 111.111.111.111  
```
nslookup ******************************.sk1.eu-west-1.eks.amazonaws.com
Server:		***.***.***.***
Address:	***.***.***.***:53

Non-authoritative answer:
Name:	******************************.sk1.eu-west-1.eks.amazonaws.com
Address: ***.***.***.***
Name:	******************************.sk1.eu-west-1.eks.amazonaws.com
Address: ***.***.***.***
Name:	******************************.sk1.eu-west-1.eks.amazonaws.com
Address: 111.111.111.111
```

```
echo "111.111.111.111"    <nome-dns-applicazione>" >> /etc/hosts
curl -kv http://<nome-dns-applicazione>:80
```

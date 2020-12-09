# DEPLOY DELLE APPLICAZIONI

La pipeline cliente presenta un Dockerfile nei repository bitbucket che viene buildata da AWS tramire il servizio CodeBuild.  
I file vengono estratti dal servizio di storage object S3.  

Sotto sono riportati i path e i nomi dei vari file yaml delle applicazioni presenti di S3 da deployare sul cluster EKS:  
- s3://cn-configs-repository/eks/<nome-applicazione>  
  - deployment.yaml  
  - service.yaml  
  - hpa.yaml  

Un esempio dei tre file yaml è presente in questo repository nella directory "deploy-yaml-applicazione-esempio".  

Parametri d'interesse:  
- il nome dell'applicazione: informazione data dal cliente,  
- il nome del namespace in cui giace l'applicazione: informazione data dal cliente,  
- IMAGE_PLACEHOLDER: l'image URI facilmente reperibile dal servizio ECR della console AWS.  
Si noti che dopo ogni build applicativo l'image URI cambia, quindi assicurarsi sempre di prendere l'URI più recente.  

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

Dopo, rimuovere l'immagine:  
```
docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
************.dkr.ecr.eu-west-1.amazonaws.com/kubectl   ***********         ***********         X months ago        XXXMB

docker rmi <IMAGE ID>
```

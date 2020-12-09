# CONNESSIONE ALL'EKS CLUSTER DI AWS

## Riferimenti ufficiali AWS

https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html  
1. Installing aws-iam-authenticator  
     https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html  
2. Create a kubeconfig for Amazon EKS  
     https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html  
3. Managing users or IAM roles for your cluster  
     https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html  


## Creazione del file di config

Riferimento: https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html  
```
mkdir -p ~/.kube
vi ~/.kube/config
export KUBECONFIG=$KUBECONFIG:~/.kube/config
echo $KUBECONFIG
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config' >> ~/.bashrc
. ~/.bash_completion
```

Il file config deve aver riportato i dati del cluster EKS. Il suddetto file è stato caricato nel repository nella directory "config-auth-eks-cluster".  
Il parametro EKS_CERTIFICATE_PRODUCTION_PLACEHOLDER si può rimpiazzare con il certificato presente nel Secret Manager della console AWS.  


## Metodo alternativo

Per velocizzare le operazioni è stato messo a disposizione un container di nome "kubectl" presente nell'ECR di AWS dove è gia tutto configurato per l'accesso al cluster EKS.  
Sotto i passi per scaricarlo e farlo partire per connettersi al cluster EKS.  
```
$(aws ecr get-login --no-include-email --region eu-west-1)
Login Succeeded
```

Ricavarsi il codice immagine dalla console AWS sotto la sezione ECR. Cercare l'immagine con il nome kubectl e poi dare il seguente comando:  
```
docker pull ***********.dkr.ecr.eu-west-1.amazonaws.com/kubectl:**************
Status: Downloaded newer image for ***********.dkr.ecr.eu-west-1.amazonaws.com/kubectl:**************
***********.dkr.ecr.eu-west-1.amazonaws.com/kubectl:**************
```

Verificare l'effettivo pull dell'immagine ed eseguire il container:
```
docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
***********.dkr.ecr.eu-west-1.amazonaws.com/kubectl    ***********         ***********         X months ago        XXXMB

docker run -it -d --name kubectl <IMAGE ID> bash
docker exec -it kubectl /bin/bash
```

Una volta dentro il container esportare il file config di autenticazione al cluster EKS:  
```
export KUBECONFIG="/opt/production"
```

Verifica connessione:  
```
echo $KUBECONFIG
kubectl get nodes
```

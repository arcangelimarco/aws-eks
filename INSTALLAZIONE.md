# INSTALLAZIONE

Per il progetto si è scelto di creare degli script automatici usando i tools IaaC AWS CloudFormation e Terraform.
In questo repository sono stati caricati tali script e in più i moduli per Fargate, anche se non utilizzati.

In questo documento invece si descrive la procedura manuale per l'installazione di un cluster EKS senza l'utilizzo di script già preconfigurati.

## Creazione del master eks senza node-group
```
eksctl create cluster --name=ekscluster --alb-ingress-access --version 1.14 --without-nodegroup --region eu-west-1
```

## Creazione delle chiavi ssh per accedere ai managed
Si consiglia di fare una coppia di chiavi per ogni managed.  
Nota: queste chiavi saranno presenti nella dashboard AWS KeyPairs, nella sezione EC2.
```
ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/ekscluster-managed-1a.pem

ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/ekscluster-managed-1b.pem

ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/ekscluster-managed-1c.pem
```

## Creazione dei managed nella rete privata e non pubblica (di default)

Di default la creazione dei managed avviene nella Subnet Pubblica.
Se si vuole crearli nella Subnet Privata si aggiunge un:
```
--node-private-networking
```
senza il flag:
```
--managed
```
non supportato con questo attributo.  
Fonte: https://eksctl.io/usage/vpc-networking/  

Se si volesse creare i managed nella Subnet Pubblica il comando è il seguente (uno per ogni AZ (1a,1b,1c)):  
```
eksctl create nodegroup --cluster ekscluster --region eu-west-1 --node-zones eu-west-1a --name ng-eu-west-1a --asg-access --node-type t2.micro --nodes-min 1 --nodes 3 --nodes-max 5 --managed --ssh-access --ssh-public-key .ssh/ekscluster-managed-1a.pem.pub
```

Creazione dei managed nella Subnet Privata (uno per ogni AZ (1a,1b,1c)):  
```
eksctl create nodegroup --cluster ekscluster --region eu-west-1 --node-zones eu-west-1a --name ng-eu-west-1a --asg-access --node-type t2.micro --nodes-min 1 --nodes 1 --nodes-max 1 --ssh-access --ssh-public-key .ssh/ekscluster-managed-1a.pem.pub --node-private-networking
eksctl create nodegroup --cluster ekscluster --region eu-west-1 --node-zones eu-west-1b --name ng-eu-west-1b --asg-access --node-type t2.micro --nodes-min 1 --nodes 1 --nodes-max 1 --ssh-access --ssh-public-key .ssh/ekscluster-managed-1b.pem.pub --node-private-networking
eksctl create nodegroup --cluster ekscluster --region eu-west-1 --node-zones eu-west-1c --name ng-eu-west-1c --asg-access --node-type t2.micro --nodes-min 1 --nodes 1 --nodes-max 1 --ssh-access --ssh-public-key .ssh/ekscluster-managed-1c.pem.pub --node-private-networking
```

Verifica:
```
kubectl get nodes
```

## Deploy per l'autoscaling  

```
wget https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

Editare il cluster-autoscaler rimpiazzando il "YOUR CLUSTER NAME" con il nome del cluster e aggiungendo le seguenti opzioni:
```
--balance-similar-node-groups
--skip-nodes-with-system-pods=false
```

Comando:
```
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
```

An example below:
```
    spec:
      containers:
      - command:
        - ./cluster-autoscaler
        - --v=4
        - --stderrthreshold=info
        - --cloud-provider=aws
        - --skip-nodes-with-local-storage=false
        - --expander=least-waste
        - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<YOUR CLUSTER NAME>
        - --balance-similar-node-groups
        - --skip-nodes-with-system-pods=false
```

Il tag per la versione si deve adeguare alle proprie esigenze:  
```
kubectl -n kube-system set image deployment.apps/cluster-autoscaler cluster-autoscaler=k8s.gcr.io/cluster-autoscaler:v1.14.7
kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler
```


# (Opzionale) Creazione dei bastion host  

Con la creazione dei managed nella subnet privata e non pubblica si necessita la creazione di tre bastion host nelle subnet pubbliche, una per ogni AZ, che serviranno da jump server per connettersi ai nodi managed.  
Risorsa AWS al seguente link: https://aws.amazon.com/it/quickstart/architecture/linux-bastion/  
Dopo la creazione dei tre bastion, collegarsi a quest'utlimi utilizzando le chiavi private dei bastion host create in precedenza.

```
ssh -i .ssh/linuxbastion-1a.pem ec2-user@ec2-***-***-***-***.eu-west-1.compute.amazonaws.com

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|
```

Dopo connttersi al managed node nella rete privata, quindi utilizzando la chiave privata del managed-1[a,b,c].  
Nel caso mostrato si è nella AZ 1a.

```
ssh -i .ssh/ekscluster-managed-1a.pem ec2-user@***.***.***.***

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|
```

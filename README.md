# aws-eks

## AWS EKS Project

AWS EKS è il servizio di containerizzazione offerto da AWS integrato con Kubernetes.  
Documentazione sito AWS: https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html  

Scelta architetturale:  

1. Ambiente produzione
	- Cluster EKS con 2 nodegroup (no Fargate)
	  - ml-lci-appliers  
		Capacity type: On-Demand  
		Minimum size:   1 nodes  
		Maximum size:   2 nodes  
		Desired size:   2 nodes  
	  - web  
		Capacity type: On-Demand  
		Minimum size:   4 nodes  
		Maximum size:  15 nodes  
		Desired size:   7 nodes  

2. Ambiente uat
	- Cluster EKS con 2 nodegroup (no Fargate)
	  - web  
		Capacity type: On-Demand  
		Minimum size:   1 nodes  
		Maximum size:   3 nodes  
		Desired size:   1 nodes  

3. Ambiente development
	- Cluster EKS con 2 nodegroup (no Fargate)
	  - web  
		Capacity type: On-Demand  
		Minimum size:   1 nodes  
		Maximum size:   3 nodes  
		Desired size:   1 nodes  

Il tutto è bilanciato da un ALB che fa da ingress, visibile nella pagina dei Load Balancer nella sezione EC2 della console AWS.  
Riconoscibile dai tag:
```
 ingress.k8s.aws/stack 				websites/websites-alb-ingress
 kubernetes.io/ingress-name 			websites-alb-ingress
 ingress.k8s.aws/cluster        		eks-01-production
 kubernetes.io/cluster/eks-01-production 	owned
 ingress.k8s.aws/resource 			LoadBalancer
 kubernetes.io/namespace        		websites
```

La documentazione è composta da quattro documenti:  
- il primo "PREREQUISITI" dove sono elencati i prerequisiti e le configurazioni necessarie,  
- il secondo "INSTALLAZIONE" dove sono elencati i passi per installare il cluster EKS,  
- il terzo "CONNESSIONE_EKS" dove sono elencati i passi per connettersi al cluster EKS,  
- il quarto "DEPLOY_APPLICAZIONI" dove sono elencati i passi per deployare le applicazioni nel cluster EKS.  


## Nota
Per policy, abilitare nell'ambiente AWS cliente per il proprio utente IAM l'autenticazione MFA.

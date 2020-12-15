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

Il tutto è bilanciato da un ALB che fa da ingress.

La pipeline cliente è composta da:  
- un project-artifact configurato su AWS CodeBuild collegato al repository bitbucker, si generano gli artifact e si caricano in AWS S3,  
- un project-build configurato su AWS CodeBuild collegato al docker repository bitbucker, si builda il docker dal Dockerfile e si pusha l'immagine buildata in ECR (che servirà al manifest yaml delle applicazioni per il pull della stessa su eks).  

La documentazione è composta da quattro documenti:  
- il primo "PREREQUISITI" dove sono elencati i prerequisiti e le configurazioni necessarie,  
- il secondo "INSTALLAZIONE" dove sono elencati i passi per installare il cluster EKS,  
- il terzo "CONNESSIONE_EKS" dove sono elencati i passi per connettersi al cluster EKS,  
- il quarto "DEPLOY_APPLICAZIONI" dove sono elencati i passi per deployare le applicazioni nel cluster EKS.  

## Nota
Per policy, abilitare nell'ambiente AWS cliente per il proprio utente IAM l'autenticazione MFA.

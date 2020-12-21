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
- un project-artifact configurato su AWS CodeBuild collegato al repository bitbucket, si generano gli artifact e si caricano in AWS S3 (s3://cn-artifacts-repository),  
- un project-build configurato su AWS CodeBuild collegato al docker repository bitbucket, si esegue la build del container dal Dockerfile e si esegue la push dell'immagine in ECR (che servirà ai manifest yaml delle applicazioni per il pull della stessa sul cluster EKS).  

La documentazione è composta da quattro documenti:  
- il primo "PREREQUISITI" dove sono elencati i prerequisiti e le configurazioni necessarie,  
- il secondo "INSTALLAZIONE" dove sono elencati i passi per installare il cluster EKS,  
- il terzo "CONNESSIONE_EKS" dove sono elencati i passi per connettersi al cluster EKS,  
- il quarto "DEPLOY_APPLICAZIONI" dove sono elencati i passi per deployare le applicazioni nel cluster EKS.  

## Nota
Si è accennato di automatizzare il processo con Jenkins per permettere a quest'ultimo di far da trigger per il CodeBuild AWS. In questo modo eseguendo la build del Jenkins job si avrebbero in modo automatico gli artifact e la docker image delle applicazioni.  
In questo caso, il cliente metterà a disposizione il codice pipeline da caricare poi nel Jenkins master server.  

## Importante
Per policy, abilitare nell'ambiente AWS cliente per il proprio utente IAM l'autenticazione MFA.

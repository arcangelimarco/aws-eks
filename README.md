# aws-eks

## AWS EKS Project

AWS EKS è il servizio di containerizzazione offerto da AWS integrato con Kubernetes.  
Documentazione sito AWS: https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html  

Scelta architetturale cliente Condè Nast:  

1. Ambiente produzione
	- Cluster EKS con 2 nodegroup (no Fargate)
	  - ml-lci-appliers (fuori dall'ambito del progetto, solo per test personali del cliente)  
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
	- Cluster EKS con 1 nodegroup (no Fargate)
	  - web  
		Capacity type: On-Demand  
		Minimum size:   1 nodes  
		Maximum size:   3 nodes  
		Desired size:   1 nodes  

3. Ambiente development
	- Cluster EKS con 1 nodegroup (no Fargate)
	  - web  
		Capacity type: On-Demand  
		Minimum size:   1 nodes  
		Maximum size:   3 nodes  
		Desired size:   1 nodes  

Il tutto è bilanciato da un ALB gestito dal cliente che fa da ingress.

Per la creazione dell'infrastruttura del progetto si è scelto di creare degli script automatici.  
Possono essere usati due IaaC tools: AWS CloudFormation o, in alternativa, Terraform.  
In questo repository sono stati caricati tali script. Si posso trovare nelle directories "CloudFormation" e "Terraform".  

## Nota bene
Per completezza si sono inseriti anche i passaggi per la creazione dell'infrastruttura da riga di comando.  
A livello progettuale le pagine "PREREQUISITI" e "INSTALLAZIONE" sono pertanto in aggiunta, da consultare, se si vuole, solo per approfondimento personale.  

## Documentazione
La documentazione è composta da cinque documenti:  
- il primo "PREREQUISITI" dove sono elencati i prerequisiti e le configurazioni necessarie,  
- il secondo "INSTALLAZIONE" dove sono elencati i passi per installare il cluster EKS,  
- il terzo "CONNESSIONE_EKS" dove sono elencati i passi per connettersi al cluster EKS,  
- il quarto "DEPLOY_APPLICAZIONI" dove sono elencati i passi per deployare le applicazioni nel cluster EKS,  
- il quinto "OPERATIVITA_AWS_CLIENTE" dov'è descritto l'ambiente AWS cliente e i servizi usati.  

## Pipeline cliente
La pipeline cliente è composta da:  
- un project-artifact configurato su AWS CodeBuild collegato al repository bitbucket, si generano gli artifact e si caricano in AWS S3 (s3://cn-artifacts-repository),  
- un project-build configurato su AWS CodeBuild collegato al docker repository bitbucket, si esegue la build del container dal Dockerfile e si esegue la push dell'immagine in ECR (che servirà ai manifest yaml delle applicazioni per il pull della stessa sul cluster EKS).  

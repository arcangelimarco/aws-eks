# aws-eks

## AWS EKS Project


### DOCUMENTAZIONE PROGETTO AWS EKS

AWS EKS è il servizio di containerizzazione offerto da AWS, oltre ad ECS.  
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



La documentazione è composta da quattro documenti:  
- il primo "PREREQUISITI" dove sono elencati tutti i prerequisiti e le configurazioni necessarie,  
- il secondo "INSTALLAZIONE" dove sono elencati tutti i passi per installare il cluster EKS,  
- il terzo "CONNESSIONE ALL'EKS CLUSTER" dove sono elencati i passi per connettersi al cluster EKS,  
- il quarto "DEPLOY DELLE APPLICAZIONI" dove sono elencati i passi per deployare le applicazioni nel cluster EKS.

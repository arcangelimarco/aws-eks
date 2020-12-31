# OPERATIVITA AMBIENTE AWS CLIENTE

I servizi interessati nell'ambiente AWS cliente sono:  
- AWS CodeBuild: servizio per la creazione degli artifact e delle build dei container,  
- AWS S3: servizio in cui sono caricati gli artifact e i manifest yaml delle applicazioni,  
- AWS ECR: servizio in cui sono caricate le immagini delle applicazioni.  

Ognuno di questi servizi può essere cercato e selezionato direttamente dalla pagina principale della console AWS scrivendone il nome nell'apposita casella di search (shortcut [ALT+S]).  

## AWS CodeBuild
Una volta nella pagina principale del servizio accedere alla sezione "Build -> Build projects" presente nella parte di sinistra.  
Cercare il nome dell'applicazione nell'apposita casella di search del servizio (es. buonissimonatale-lci).  
Si troveranno due project, facilmente distinguibili dalla parola "artifacts" e "build", come mostrato nei due esempi sotto:  
- nome-applicazione-create-artifacts: creazione degli artifacts (es. cn-buonissimonatale-lci-wp-create-artifacts),  
- nome-applicazione-build: build del container (cn-buonissimonatale-lci-wp-build).  

Il primo esegue la creazione degli artifact, salvati in S3 sotto s3://cn-artifacts-repository/nome-applicazione (es. s3://cn-artifacts-repository/buonissimonatale-lci-wp/).  
Il secondo esegue la build del container e la push dell'immagine nell'AWS ECR (non viene salvato nessun file in S3).  

Per il deploy delle applicazioni i manifest yaml vengono caricati manualmente in S3 nel path s3://cn-configs-repository/eks/nome-applicazione (es. s3://cn-configs-repository/eks/buonissimonatale/).  
In questo path sono presenti i tre manifest (uno per ogni applicazione):  
- deployment.yaml  
- hpa.yaml  
- service.yaml  

### Start del CodeBuild project
Una volta selezionato il project (artifacts o build) cliccare sul bottone in alto a destra "Start build" per iniziare la build.  
Per velocizzare le operazioni si può selezionare una build dalla sezione sottostante nominata "Build history" e poi cliccare sul bottone "Retry build".  
In questo modo si esegue di nuovo la build selezionata.  

## AWS ECR
Una volta nella pagina principale del servizio accedere alla sezione "Repositories" presente nella parte di sinistra.  
Cercare il nome dell'applicazione nell'apposita casella di search del servizio (es. buonissimonatale-lci-wp).  
Selezionando il repositoy viene mostrata la lista di tutte le push delle immagini, ogununa con un tag diverso.  
Fare click sulla scritta "Copy URI" nella quarta colonna denominata "Image URI" per copiare l'URI dell'immagine (comprensiva del tag). Questa verrà usata nel manifest deployment.yaml della rispettiva applicazione.  

## AWS S3

Buckets interessati:  
- s3://cn-artifacts-repository/  
- s3://cn-configs-repository/eks/  

Una volta nella pagina principale del servizio accedere alla sezione "Buckets" presente nella parte di sinistra.  
Cercare nell'apposita casella di search del servizio la parola "repository".
Si ottengono i due buckets sottostanti:  
- cn-artifacts-repository: contiene gli artifacts delle applicazioni (scaturite dall'avvio del project CodeBuild "nome-applicazione-create-artifacts"),  
- cn-configs-repository: contiene sotto la directory "eks" i manifest yaml delle varie applicazioni (si caricano manualmente).  

## Lista delle applicazioni migrate su EKS
Link Sharepoint al file excel contenente le applicazioni del progetto:  
https://sinthera.sharepoint.com/tecnici/Documenti/Forms/AllItems.aspx?viewid=e06fe87c%2D805e%2D4326%2Db40d%2Dcee46c288d9a&id=%2Ftecnici%2FDocumenti%2FClienti%2FConde%20Nast  

Sotto sono elencati i nomi delle applicazioni presenti in s3://cn-configs-repository/eks/.  
Sotto a questi è elencata la discriminante per le host rules dell'ingress (campo server_name del file nginx.conf nei repository bitbucket cliente).

- polls  
  - polls.glamour.it  
  - polls.wired.it  
  - polls.vanityfair.it  
- recommendations-php  
  - recommendations.condenet.it  
- comments-back-office
  - bo-comments.condenast.it  
- comments-api
  - api-comments.condenast.it  
- buonissimonatale  
  - buonissimonatale.lacucinaitaliana.it  
- coupons  
  - coupons.condenet.it  
- condenast-wp-subscriptions  
  - iscrizioni.condenast.it 
- condenast-wp-social-academy-api  
  - socialacademy-api.condenast.it  
- condenast-wp-social-academy  
  - socialacademy.condenast.it  
- socialtalentagency
  - socialtalentagency.condenast.it  
- vogue-petition  
  - petizione.vogue.it  
- cnlive-wp
  - www.cnlive.it  

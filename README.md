# aws-eks
AWS EKS Project


################ DOCUMENTAZIONE PROGETTO AWS EKS ################

AWS EKS è il servizio di containerizzazione offerto da AWS, oltre ad ECS.
Documentazione sito AWS:
https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

Scelta architetturale cliente:
3 cluster EKS per i 3 ambienti: production, uat, development

Ambiente produzione:
	Cluster EKS con 2 nodegroup (no Fargate):
	eks-01-production:
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

Ambiente uat:
	Cluster EKS con 2 nodegroup (no Fargate):
	eks-01-uat:
	- web
		Capacity type: On-Demand
		Minimum size:   1 nodes
		Maximum size:   3 nodes
		Desired size:   1 nodes

Ambiente development:
	Cluster EKS con 2 nodegroup (no Fargate):
	eks-01-development:
	- web
		Capacity type: On-Demand
		Minimum size:   1 nodes
		Maximum size:   3 nodes
		Desired size:   1 nodes



#### PREREQUISITI

Installazione kubectl:

curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
yum -y install jq gettext bash-completion

Nota: per installare jq bisogna abilitare il repo di fedoraproject

cat <<EOF > /etc/yum.repos.d/epel-fedora.repo
[epel-fedora]
name=epel-fedora repo
baseurl=https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/
enable=1
gpgcheck=0
EOF

for command in kubectl jq envsubst; do which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"; done
kubectl completion bash >>  ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion

Nel caso ci fossero delle creds spurie:

rm -vf ${HOME}/.aws/credentials


Installazione pip e phyton2 (o versioni successive) per awscli: download pip dal repository ufficiale e installarlo usando curl e python:

curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
yum install phyton2 -y
python get-pip.py

Controllare la corretta installazione di pip:

pip -V


Insallazione della awscli e di eksctl:

pip install awscli --upgrade --user
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv -v /tmp/eksctl /usr/local/bin


Controllare la corretta installazione di eksctl:

eksctl version


Ultime operazioni:

eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
cd .local/bin/
cp aws* /usr/local/bin/
aws --version


Configurare AWS con le chiavi del profilo utente IAM, reperibili dalla console AWS o crearne un paio nuove, sempre dalla console AWS.
Definire la regione di default e il formato di output di default (di solito json):

aws configure
AWS Access Key ID [None]: ************
AWS Secret Access Key [None]: ********************************
Default region name [None]: <YOUR-DEFAULT-REGION>
Default output format [None]: <YOUR-DEFAULT-OUTPUT>


Download dell'iam-authenticator:

curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
cat aws-iam-authenticator.sha256
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=<YOUR-DEFAULT-REGION>
test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region
aws sts get-caller-identity
{
    "Account": "000395417872",
    "UserId": "AIDAQAF4RTEIAZTGMUWED",
    "Arn": "arn:aws:iam::000395417872:user/marco"
}

L’ARN e la REGION deve essere congruo con le credenziali del proprio account.

# PREREQUISITI

## Installazione kubectl

Si noti che in questo caso si è scaricata la versione 1.14.6.  
Per altre versioni seguire il link ufficiale aws:  
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html  

```
curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
yum -y install jq gettext bash-completion
```

Controllo dei comandi:

```
for command in kubectl jq envsubst; do which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"; done
```

Nota: per installare jq bisogna abilitare il repo di fedoraproject  
```
cat <<EOF > /etc/yum.repos.d/epel-fedora.repo
[epel-fedora]
name=epel-fedora repo
baseurl=https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/
enable=1
gpgcheck=0
EOF
```

Ultime operazioni:  
```
kubectl completion bash >>  ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
```

## Installazione pip e phyton2 (o versioni successive) per awscli  

Download pip dal repository ufficiale e installarlo usando curl e python:  
```
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
yum install phyton2 -y
python get-pip.py
```

Controllare la corretta installazione di pip:  
```
pip -V
```

## Insallazione della awscli e di eksctl  

```
pip install awscli --upgrade --user
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv -v /tmp/eksctl /usr/local/bin
```

Controllare la corretta installazione di eksctl:  
```
eksctl version
```

Ultime operazioni:  
```
eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
cd .local/bin/
cp aws* /usr/local/bin/
aws --version
```

## Configurare le credenziali AWS  

Per configurare le credenziali AWS si fa uso delle chiavi del proprio profilo utente IAM, reperibili dalla console AWS.  
In alternativa se ne può crearne un paio nuove, sempre dalla console AWS.  

Nel caso ci fossero delle credenziali spurie:  
```
rm -vf ${HOME}/.aws/credentials
```

Definire la regione di default e il formato di output di default (di solito json):  
```
aws configure
AWS Access Key ID [None]: ************
AWS Secret Access Key [None]: ********************************
Default region name [None]: <YOUR-DEFAULT-REGION>
Default output format [None]: <YOUR-DEFAULT-OUTPUT>
```

## Download dell'iam-authenticator  

```
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
```

Verifica del file binario scaricato:
```
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
cat aws-iam-authenticator.sha256
```

Ultime operazioni:  
```
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=<YOUR-DEFAULT-REGION>
test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
```

Verificare che l’ARN e la REGION siano congrui con le credenziali del proprio account AWS:  
```
aws configure get default.region
aws sts get-caller-identity
{
    "Account": "***********",
    "UserId": "*******************",
    "Arn": "arn:aws:iam::***********:user/*******"
}
```

## Nota
Per policy, abilitare nell'ambiente AWS cliente per il proprio utente IAM l'autenticazione MFA.

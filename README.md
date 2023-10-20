# aws-jenkins

Demo to show Infrastructure as Code, Pipeline as Code
## main branch: 
Setup 1 VPC with 2 public Subnets, with Internet Gateway, Route Table, Security Group

Setup Application Load Balancer, AutoScaling Group, 2 ubuntu instances in 2 Available Zones, with static website deployed
```
Folders:

network/
compute/
script/
main.tf
outputs.tf
providers.tf
backend.tf

Jenkinsfile

=========================
Commands: 

terraform fmt
terraform plan
terraform apply -auto-approve
terraform destroy
```

## local-jenkins folder
Setup jenkins at local


```
local-jenkins/
    Dockerfile
    main.tf

========================
cd local-jenkins
docker build -t jenkins:terraform .
docker image ls

terraform init
terraform plan -out=tfplan
terraform apply tfplan

docker container ls
docker volume ls
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

http://localhost:8080/login?from=%2F
Install plugins:
Terraform
AWS Credentials
ansiColor
Locale
    systemLocale: en
    ignoreAcceptLanguage: true

Ensure that you have the following plugins installed on Jenkins.

    Stage Step Pipeline
    SCM Step Pipeline
    Multibranch Pipeline
    Input Step Pipeline
    Declarative Pipeline
    Basic Steps Pipeline
    Build Step Pipeline
    Terraform Plugin
    Workspace Cleanup
    Plain Credentials
    Credentials Binding
    Build Timeout
    AnsiColor



docker stop jenkins
docker start jenkins

Setup Terraform
http://localhost:8080/manage/configureTools/
    Add Terraform

http://localhost:8080/manage/credentials/
cat ~/.aws/credentials

docker exec -it jenkins bash
```

## static branch

Example of static website. Only one page to show hostname

Created branch static with index.html to similate a separate static website

```
static/
    index.html
```
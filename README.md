# aws-jenkins

## main branch

Setup Application Load Balancer, ASG, 2 instance, with static website deployed

```
terraform fmt
terraform plan
terraform apply -auto-approve
terraform destroy
```

## jenkins branch
Setup jenkins at local

```
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
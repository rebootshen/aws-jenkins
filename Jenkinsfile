pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }


     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    
    options { ansiColor('xterm') } 

    stages {
        stage('Checkout') {
            steps {
                script{
                        dir("terraform")
                        {
                            cleanWs()
                            git branch: 'main', url: 'https://github.com/rebootshen/aws-jenkins.git'
                        }
                    }
                }
            }
        stage ('Terraform Init') { 
            steps {
                println(WORKSPACE)
                sh '''
                    cd terraform
                    pwd; terraform --version
                    pwd; terraform init -input=false
                    pwd; terraform workspace select ${environment} || terraform workspace new ${environment}
                ''' 
                }
        }

        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                sh '''
                    cd terraform
                    pwd; terraform plan -input=false -out tfplan
                '''
            }
        }


        stage('Approval') {
           steps {
                echo 'Approve the plan'
           }
       }

        stage('Apply') {
            steps {
                echo 'Deploy the application'
            }
        }
        
        stage('Destroy') {
            steps {
                echo 'Destroy the application'
            }
    }

  }
}
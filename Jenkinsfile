pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: true, description: 'Automatically run apply after generating plan?')
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
                    pwd; terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }


        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           
           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                echo 'Deploy the application'
            }
        }
        
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
            steps {
                echo 'Destroy the application'
            }
    }

  }
}
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
        stage('Checkout1') {
            steps {
                sh 'pwd'
                sh 'mkdir terraform'
                echo "git branch: 'main', credentialsId: 'credentials', url: 'https://github.com/rebootshen/aws-jenkins.git'"
                sh 'git clone -b main https://github.com/rebootshen/aws-jenkins.git terraform/'
            }

        }
        stage ('Terraform Init') { 
            steps {
                println(WORKSPACE)
                sh '''
                    cd terraform/
                    pwd
                    terraform --version
                    terraform init -input=false
                    terraform workspace select ${environment} || terraform workspace new ${environment}
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
                    cd terraform/
                    terraform plan -input=false -out tfplan
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }


        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }
           
           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }
            
            steps {
                echo 'Deploy the application'
            }
        }
        
        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }
        
            steps {
                echo 'Destroy the application'
            }
    }

  }
}

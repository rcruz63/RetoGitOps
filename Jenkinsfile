#!groovy

@Library('github.com/ayudadigital/jenkins-pipeline-library@v6.3.0') 

// Initialize global config
cfg = jplConfig('RetoGitOps', 'backend' ,'', [email: 'rcruz2@mapfre.com'])
cfg.commitValidation.enabled = false

pipeline {

    agent any
   
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }  
    
    stages {
        stage("Initialize") {
            steps {
                jplStart(cfg)
                script {
                  dir ("terraform") {
                    sh "terraform init"
                  }
                }
            }
        }

        stage ("Terraform init") {
            steps {
                script {
                  dir ("terraform") {
                    sh "terraform init"
                  }
                }
            }
        }
        stage ("Terraform destroy ") {
            when {  branch 'feature/destroy'  }
            steps {
                script {
                  dir("ansible"){
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh """
                        ansible-playbook destroy.yml
                      """
                    }

                  }
                  dir ("terraform") {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh "terraform destroy -input=false -auto-approve"
                    }
                  }
                }
            }
        }

        
        stage ("Terraform show") {
            steps {
                script {
                  dir ("terraform") {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh "terraform show"
                    }
                  }
                }
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }
}



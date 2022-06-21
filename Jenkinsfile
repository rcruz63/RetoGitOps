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
                sh "terraform init"
            }
        }

        stage("AWS Credentials") {
            steps {
                /*withCredentials(
                    [
                        string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                        string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]
                ) {*/
                    sh 'echo ${AWS_ACCESS_KEY_ID}'
                    echo AWS_ACCESS_KEY_ID
                }
            }
        }

        stage ("Terraform init") {
            steps {
                sh 'echo ${AWS_ACCESS_KEY_ID}'
                sh "terraform init"
            }
        }
        stage ("Terraform plan") {
            when { not { branch 'main' } }
            steps {
                sh "terraform plan"
            }
        }

        // stage "test"
        stage("test") {
            when {
                branch 'PR-*'
            }
            steps {
                echo "test"
            }
        }

        // stage "master" terraform apply
        stage("master") {
            when { branch 'main' }
            steps {
                sh """
                    terraform plan -out=reto.plan
                    terraform apply reto.plan
                """
            }
        }
        stage ("Terraform show") {
            steps {
                sh "terraform show"
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



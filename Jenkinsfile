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
        stage ("Terraform plan") {
            when { not { branch 'main' } }
            steps {
                script {
                  dir ("terraform") {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh "terraform plan"
                    }
                  }
                }
            }
        }

        stage ("Sonar: Regular Branch Check") {
            when { not { branch 'PR-*' } }
            steps {
                // Make analysis of the branch with SonarScanner and send it to SonarCloud
                withSonarQubeEnv ('RcsSonar') {
                    sh '~/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner \
                        -Dsonar.organization=rcruz63 \
                        -Dsonar.projectKey=rcruz63_RetoGitOps \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.branch.name="$BRANCH_NAME"'
                }
            }
        }
        stage ("Sonar: PR Check") {
            when { branch 'PR-*' }
            steps {
                // Make analysis of the PR with SonarScanner and send it to SonarCloud
                // Reference: https://blog.jdriven.com/2019/08/sonarcloud-github-pull-request-analysis-from-jenkins/
                withSonarQubeEnv ('RcsSonar') {
                    sh "~/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner \
                        -Dsonar.organization=rcruz63 \
                        -Dsonar.projectKey=rcruz63_RetoGitOps \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.pullrequest.provider='GitHub' \
                        -Dsonar.pullrequest.github.repository='rcruz63/RetoGitOps' \
                        -Dsonar.pullrequest.key='${env.CHANGE_ID}' \
                        -Dsonar.pullrequest.branch='${env.CHANGE_BRANCH}'"
                }
            }
        }
        stage ("Sonar: Wait for QG") {
            steps {
                // Wait for QuaityGate webhook result
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        // stage "test"
        stage("test") {
            steps {
                script {
                  dir ("ansible") {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {

                      sh "ansible-playbook s3_web.yml --check"
                    }
                  }
                }
            }
        }
        

        // stage "master" terraform apply
        stage("master") {
            when { branch 'master' }
            steps {
                script {
                  dir ("terraform") {
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh """
                        terraform plan -out=reto.plan
                        terraform apply -input=false -auto-approve reto.plan
                      """
                    }
                  }
                  dir("ansible"){
                    withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'), 
                                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                      sh """
                        ansible-playbook s3_web.yml
                      """
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



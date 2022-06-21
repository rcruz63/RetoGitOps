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

        stage ("Terraform init") {
            steps {
                sh "terraform init"
            }
        }
        stage ("Terraform plan") {
            when { not { branch 'main' } }
            steps {
                sh "terraform plan"
            }
        }

        /*stage ("Sonar: Regular Branch Check") {
            when { not { branch 'PR-*' } }
            steps {
                sh '''export SONAR_SCANNER_VERSION=4.7.0.2747
                      export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
                      curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
                      unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
                      export PATH=$SONAR_SCANNER_HOME/bin:$PATH
                      export SONAR_SCANNER_OPTS="-server"'''
                // Make analysis of the branch with SonarScanner and send it to SonarCloud
                withSonarQubeEnv ('RcsSonar') {
                    sh 'sonar-scanner \
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
                    sh "sonar-scanner \
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
                    waitForQualityGate abortPipeline: true
                }
            }
        }*/

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



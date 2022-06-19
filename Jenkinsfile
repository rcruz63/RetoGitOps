// Pipeline "Hello World!"

pipeline {

  agent any

    stages {
        stage("always") {
            steps {
                echo "sh terraform plan"
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
            when {
                branch 'master'
            }
            steps {
                echo "sh terraform apply"
            }
        }
    }
}



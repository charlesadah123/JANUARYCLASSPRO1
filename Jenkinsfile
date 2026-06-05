
    pipeline {
    agent any

    tools {
        jdk 'myjava'
        maven 'mymaven'
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/charlesadah123/JANUARYCLASSPRO1.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Code Analysis (PMD)') {
            steps {
                sh 'mvn pmd:pmd'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh 'docker rm -f myapp || true'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 8081:8080 --name myapp myapp:latest'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'app.log', allowEmptyArchive: true
        }

        success {
            echo 'Application running in Docker on port 8081'
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}


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

         stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-cred') {
                        sh 'docker push charlesadah/myapp:latest'
                    }
                }
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
             echo 'Pipeline finished.'
        }

        success {
             echo 'SUCCESS: App built, pushed to Docker Hub, and running on port 8081.'
        }

        failure {
           echo 'FAILED: Check Jenkins logs for errors.'
        }
    }
}

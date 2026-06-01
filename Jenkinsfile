pipeline {
    tools {
        // Ensure these tool names match your Jenkins Global Tool Configuration
        jdk 'myjava'
        maven 'mymaven'
    }
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                git 'https://github.com/charlesadah123/JANUARYCLASSPRO1.git'
            }
        }

        stage('Compile') {
            steps {
                echo 'Compiling source code...'
                sh 'mvn clean compile' // 'clean' is important to avoid old state
            }
        }

        stage('Code Analysis (PMD)') {
            steps {
                echo 'Running PMD for code review...'
                sh 'mvn pmd:pmd'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging application...'
                sh 'mvn package -DskipTests' // Skipping tests to save time; run them in a dedicated test stage in production.
            }
        }

        stage('Cleanup & Run') {
            steps {
                echo 'Stopping any existing application process...'
                // This finds and stops the process running on port 8080
                sh '''
                    # Find the process ID (PID) using port 8080 and kill it
                    PID=$(sudo lsof -t -i:8080) || true
                    if [ -n "$PID" ]; then
                        echo "Stopping process $PID using port 8080"
                        sudo kill -9 $PID
                    else
                        echo "Port 8080 is free."
                    fi
                '''
            }
        }

        stage('Deploy & Run') {
            steps {
                echo 'Running the application...'
                // Run the WAR file in the background and log output
                sh 'nohup java -jar webapp/target/*.war > app.log 2>&1 &'
                echo 'Application started. Check app.log for output.'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
            // Archive the logs as a build artifact for debugging
            archiveArtifacts artifacts: 'app.log', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline failed! Check the logs.'
        }
        success {
            echo 'Pipeline succeeded! The application should be running on port 8080.'
        }
    }
}

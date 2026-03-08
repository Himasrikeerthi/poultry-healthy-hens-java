pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "himasrikeerthi/poultryfarm:latest"
        DOCKER_CREDENTIALS = credentials('Hima_Docker_Hub')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Himasrikeerthi/poultry-healthy-hens-java.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'Hima_Docker_Hub', url: 'https://index.docker.io/v1/']) {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                docker rm -f poultryfarm || true
                docker run -d --name poultryfarm -p 2001:8080 ${DOCKER_IMAGE}
                """
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

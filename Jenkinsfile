pipeline {
    agent any

    environment {
        IMAGE_NAME = 'himasrikeerthi/poultry-app'
        TAG = 'latest'
    }

    stages {

        stage('Clone Code') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/Himasrikeerthi/poultry-healthy-hens-java.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME:$TAG
                    '''
                }
            }
        }

        stage('Check Files') {
            steps {
                sh 'pwd'
                sh 'ls -l'
                sh 'ls -l k8s || true'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                aws eks --region ap-south-1 update-kubeconfig --name mycluster

                kubectl apply -f deployment.yml --validate=false || kubectl apply -f k8s/deployment.yml --validate=false
                kubectl apply -f service.yml --validate=false || kubectl apply -f k8s/service.yml --validate=false
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully '
        }
        failure {
            echo 'Pipeline failed '
        }
    }
}

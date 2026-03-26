pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-creds',
                    url: 'https://github.com/Himasrikeerthi/poultry-healthy-hens-java.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t himasrikeerthi/poultry-app:latest .'
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push himasrikeerthi/poultry-app:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
    steps {
        sh '''
        set -e
        set -x

        echo "Configuring AWS access..."
        aws sts get-caller-identity

        echo "Updating kubeconfig..."
        aws eks --region ap-south-1 update-kubeconfig --name mycluster

        echo "Checking cluster access..."
        kubectl get nodes

        echo "Deploying application..."
        kubectl apply -f poultry-deploy-service.yml

        echo "Verifying deployment..."
        kubectl get pods
        kubectl get svc
        '''}
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}

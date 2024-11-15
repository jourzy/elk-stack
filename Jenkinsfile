pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds') // Optional
    }

    stages {
        // Stage 1: Terraform Infrastructure Provisioning
        stage('Terraform Init & Apply') {
            steps {
                script {
                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        // Stage 2: Docker Build and Push (Optional if using DockerHub)
        stage('Docker Build & Push') {
            steps {
                script {
                    dir('docker') {
                        sh 'docker build -t nginx-app .'
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                            sh 'docker tag nginx-app $DOCKER_USER/nginx-app:latest'
                            sh 'docker push $DOCKER_USER/nginx-app:latest'
                        }
                    }
                }
            }
        }

        // Stage 3: Run Docker Containers with Docker Compose
        stage('Deploy Docker Containers') {
            steps {
                script {
                    dir('docker') {
                        sh 'docker-compose up -d'
                    }
                }
            }
        }

        // Stage 4: Ansible Configuration
        stage('Ansible Provisioning') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'ansible/playbook.yml',
                        inventory: 'ansible/hosts',
                        extras: '--key-file ~/.ssh/your-ssh-key.pem',
                        sudoUser: 'ec2-user'
                    )
                }
            }
        }

        // Stage 5: Testing (Optional)
        stage('Testing') {
            steps {
                script {
                    // Add your test scripts here, e.g., health checks for the web app
                    sh 'curl http://<nginx-public-ip> | grep "Welcome"'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}

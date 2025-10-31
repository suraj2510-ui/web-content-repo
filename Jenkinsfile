pipeline {
    agent any

    environment {
        AWS_SSH_CONFIG = 'AWS_APP_MACHINE'
        AZURE_SSH_CONFIG = 'AZURE_VM'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out source code from GitHub...'
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Test SSH Connection - AWS') {
            steps {
                echo 'Testing SSH connectivity to AWS App Machine...'
                sh 'ssh -o StrictHostKeyChecking=no aws-app hostname'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo 'Deploying web content to AWS App Machine...'
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "${AWS_SSH_CONFIG}",
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: '**/*',
                                        removePrefix: '',
                                        remoteDirectory: '/tmp/deploy',   // ✅ CHANGED HERE
                                        execCommand: '''
                                            echo "Starting deployment on AWS..."
                                            sudo mkdir -p /var/www/html
                                            sudo rm -rf /var/www/html/*
                                            sudo cp -r /tmp/deploy/* /var/www/html/
                                            sudo chown -R www-data:www-data /var/www/html
                                            sudo systemctl restart nginx
                                            echo "✅ Deployment completed on AWS!"
                                        '''
                                    )
                                ],
                                verbose: true
                            )
                        ]
                    )
                }
            }
        }

        stage('Test SSH Connection - Azure') {
            steps {
                echo 'Testing SSH connectivity to Azure VM...'
                sh 'ssh -o StrictHostKeyChecking=no azure-vm uptime'
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo 'Deploying web content to Azure VM...'
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: "${AZURE_SSH_CONFIG}",
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: '**/*',
                                        removePrefix: '',
                                        remoteDirectory: '/tmp/deploy',   // ✅ CHANGED HERE
                                        execCommand: '''
                                            echo "Starting deployment on Azure..."
                                            sudo mkdir -p /var/www/html
                                            sudo rm -rf /var/www/html/*
                                            sudo cp -r /tmp/deploy/* /var/www/html/
                                            sudo chown -R www-data:www-data /var/www/html
                                            sudo systemctl restart nginx
                                            echo "✅ Deployment completed on Azure!"
                                        '''
                                    )
                                ],
                                verbose: true
                            )
                        ]
                    )
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}

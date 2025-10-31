pipeline {
    agent any

    environment {
        AWS_HOST = '44.223.87.153'
        AZURE_HOST = '172.172.76.52'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '📦 Checking out source code from GitHub...'
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Test SSH Connection - AWS') {
            steps {
                echo '🔗 Testing SSH connectivity to AWS App Machine...'
                sh 'ssh -o StrictHostKeyChecking=no aws-app hostname'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo '🚀 Deploying web content to AWS App Machine...'
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    remoteDirectory: '/tmp/deploy',
                                    execCommand: '''
                                        echo "Starting AWS deployment..."
                                        sudo mkdir -p /var/www/html
                                        sudo mv /tmp/deploy/index-aws.html /var/www/html/index.nginx-debian.html
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ AWS deployment completed successfully!"
                                    '''
                                )
                            ],
                            verbose: true
                        )
                    ])
                }
            }
        }

        stage('Test SSH Connection - Azure') {
            steps {
                echo '🔗 Testing SSH connectivity to Azure VM...'
                sh 'ssh -o StrictHostKeyChecking=no azure-vm uptime'
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo '🚀 Deploying web content to Azure VM...'
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    remoteDirectory: '/tmp/deploy',
                                    execCommand: '''
                                        echo "Starting Azure deployment..."
                                        sudo mkdir -p /var/www/html
                                        sudo mv /tmp/deploy/index-azure.html /var/www/html/index.nginx-debian.html
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ Azure deployment completed successfully!"
                                    '''
                                )
                            ],
                            verbose: true
                        )
                    ])
                }
            }
        }
    }

    post {
        always {
            echo '🧾 Pipeline finished.'
        }
    }
}

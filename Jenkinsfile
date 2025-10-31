pipeline {
    agent any

    environment {
        AWS_SSH_CONFIG = 'aws-app-server'      // Jenkins SSH config name for AWS EC2
        AZURE_SSH_CONFIG = 'azure-web-server'  // Jenkins SSH config name for Azure VM
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Build') {
            steps {
                echo '✅ Build stage — static HTML, so nothing to compile.'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo '🚀 Deploying to AWS App Machine...'
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: "${AWS_SSH_CONFIG}",
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'index-aws.html',
                                remoteDirectory: '/tmp',
                                execCommand: '''
                                    echo "Moving file to nginx directory..."
                                    sudo mv /tmp/index-aws.html /var/www/html/index.nginx-debian.html
                                    sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                    sudo chmod 644 /var/www/html/index.nginx-debian.html
                                    sudo systemctl restart nginx
                                    echo "✅ AWS Deployment completed!"
                                '''
                            )
                        ],
                        verbose: true
                    )
                ])
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo '🚀 Deploying to Azure VM...'
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: "${AZURE_SSH_CONFIG}",
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'index-azure.html',
                                remoteDirectory: '/tmp',
                                execCommand: '''
                                    echo "Moving file to nginx directory..."
                                    sudo mv /tmp/index-azure.html /var/www/html/index.nginx-debian.html
                                    sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                    sudo chmod 644 /var/www/html/index.nginx-debian.html
                                    sudo systemctl restart nginx
                                    echo "✅ Azure Deployment completed!"
                                '''
                            )
                        ],
                        verbose: true
                    )
                ])
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '🔍 Verifying deployments...'
                script {
                    def awsCheck = sh(script: "curl -I http://<AWS_PUBLIC_IP> | grep 'HTTP/' || true", returnStdout: true).trim()
                    def azureCheck = sh(script: "curl -I http://<AZURE_PUBLIC_IP> | grep 'HTTP/' || true", returnStdout: true).trim()

                    echo "AWS Response: ${awsCheck}"
                    echo "Azure Response: ${azureCheck}"

                    if (!awsCheck.contains('200') || !azureCheck.contains('200')) {
                        error("❌ Deployment verification failed. Check Nginx or permissions.")
                    } else {
                        echo '🎉 Deployment successful on both AWS and Azure!'
                    }
                }
            }
        }
    }
}

pipeline {
    agent any

    environment {
        AWS_SSH_CONFIG = 'AWS_APP_MACHINE'
        AZURE_SSH_CONFIG = 'AZURE_VM'
        TEMP_DIR = '/tmp'
        NGINX_HTML_PATH = '/var/www/html'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out web content from GitHub..."
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo "🚀 Deploying to AWS App Machine..."
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: "${AWS_SSH_CONFIG}",
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    remoteDirectory: "${TEMP_DIR}",
                                    execCommand: """
                                        echo "Moving file to nginx directory..."
                                        sudo mv ${TEMP_DIR}/index-aws.html ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo chown www-data:www-data ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo chmod 644 ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ AWS Deployment completed!"
                                    """
                                )
                            ],
                            verbose: true
                        )
                    ])
                }
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo "🚀 Deploying to Azure VM..."
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: "${AZURE_SSH_CONFIG}",
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    remoteDirectory: "${TEMP_DIR}",
                                    execCommand: """
                                        echo "Moving file to nginx directory..."
                                        sudo mv ${TEMP_DIR}/index-azure.html ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo chown www-data:www-data ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo chmod 644 ${NGINX_HTML_PATH}/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ Azure Deployment completed!"
                                    """
                                )
                            ],
                            verbose: true
                        )
                    ])
                }
            }
        }

        stage('Verify Deployments') {
            steps {
                echo "🔍 Verifying Nginx responses..."
                script {
                    sh '''
                        echo "Checking AWS response..."
                        ssh -o StrictHostKeyChecking=no aws-app "curl -I http://localhost | head -n 1"

                        echo "Checking Azure response..."
                        ssh -o StrictHostKeyChecking=no azure-vm "curl -I http://localhost | head -n 1"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "🧾 Pipeline finished."
        }
        success {
            echo "🎉 Deployment successful on both AWS and Azure!"
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins logs for details."
        }
    }
}

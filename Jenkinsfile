pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo "📥 Checking out source code..."
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "⚙️ Building the project..."
                // (Optional) Add build steps if needed
            }
        }

        stage('Deploy to AWS') {
            steps {
                echo "🚀 Deploying to AWS..."
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE', // Jenkins SSH host config name
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html', // File to deploy
                                    removePrefix: '',
                                    remoteDirectory: '/tmp', // Upload temp directory
                                    execCommand: '''
                                        echo "Starting AWS deployment..."
                                        sudo mkdir -p /var/www/html
                                        sudo mv /tmp/index-aws.html /var/www/html/index.nginx-debian.html
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ AWS deployment completed successfully!"
                                    '''
                                )
                            ]
                        )
                    ]
                )
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo "🚀 Deploying to Azure..."
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM', // Jenkins SSH host config name
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html', // File to deploy
                                    removePrefix: '',
                                    remoteDirectory: '/tmp', // Upload temp directory
                                    execCommand: '''
                                        echo "Starting Azure deployment..."
                                        sudo mkdir -p /var/www/html
                                        sudo mv /tmp/index-azure.html /var/www/html/index.nginx-debian.html
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "✅ Azure deployment completed successfully!"
                                    '''
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment completed successfully for AWS and Azure!"
        }
        failure {
            echo "❌ Deployment failed — please check Jenkins logs for details."
        }
    }
}

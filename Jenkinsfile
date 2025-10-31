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
                                        # Create directory if it doesn't exist
                                        sudo mkdir -p /var/www/html
                                        echo "Permissions of /var/www/html before move:"
                                        sudo ls -la /var/www/ | grep html || true
                                        sudo ls -la /var/www/html || true

                                        # Move the deployed file to its final location
                                        sudo mv /tmp/index-aws.html /var/www/html/index.nginx-debian.html
                                        echo "File moved. Permissions of index.nginx-debian.html after move:"
                                        sudo ls -la /var/www/html/index.nginx-debian.html || true

                                        # Set owner, group, and permissions
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        echo "Permissions after chown/chmod:"
                                        sudo ls -la /var/www/html/index.nginx-debian.html || true

                                        # Ensure Nginx can read the directory (should be default but good to verify)
                                        sudo chmod a+rx /var/www/html
                                        echo "Directory permissions after chmod a+rx:"
                                        sudo ls -la /var/www/ | grep html || true

                                        # Restart Nginx and check status
                                        sudo systemctl daemon-reload
                                        sudo systemctl restart nginx
                                        echo "Nginx service status after restart:"
                                        sudo systemctl status nginx --no-pager

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
                                        # Create directory if it doesn't exist
                                        sudo mkdir -p /var/www/html
                                        echo "Permissions of /var/www/html before move:"
                                        sudo ls -la /var/www/ | grep html || true
                                        sudo ls -la /var/www/html || true

                                        # Move the deployed file to its final location
                                        sudo mv /tmp/index-azure.html /var/www/html/index.nginx-debian.html
                                        echo "File moved. Permissions of index.nginx-debian.html after move:"
                                        sudo ls -la /var/www/html/index.nginx-debian.html || true

                                        # Set owner, group, and permissions
                                        sudo chown www-data:www-data /var/www/html/index.nginx-debian.html
                                        sudo chmod 644 /var/www/html/index.nginx-debian.html
                                        echo "Permissions after chown/chmod:"
                                        sudo ls -la /var/www/html/index.nginx-debian.html || true

                                        # Ensure Nginx can read the directory
                                        sudo chmod a+rx /var/www/html
                                        echo "Directory permissions after chmod a+rx:"
                                        sudo ls -la /var/www/ | grep html || true

                                        # Restart Nginx and check status
                                        sudo systemctl daemon-reload
                                        sudo systemctl restart nginx
                                        echo "Nginx service status after restart:"
                                        sudo systemctl status nginx --no-pager

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

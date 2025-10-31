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
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'AWS_APP_MACHINE',
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'index-aws.html',
                                removePrefix: '',
                                remoteDirectory: '/tmp'
                            )
                        ],
                        verbose: true,
                        failOnError: true,
                        execCommand: '''
                            set -e
                            echo "Starting AWS deployment..."
                            sudo -n mkdir -p /var/www/html
                            echo "Permissions of /var/www/html before move:"
                            sudo -n ls -la /var/www/ | grep html || true
                            sudo -n ls -la /var/www/html || true

                            sudo -n mv /tmp/index-aws.html /var/www/html/index.nginx-debian.html
                            echo "File moved. Permissions of index.nginx-debian.html after move:"
                            sudo -n ls -la /var/www/html/index.nginx-debian.html || true

                            sudo -n chown www-data:www-data /var/www/html/index.nginx-debian.html
                            sudo -n chmod 644 /var/www/html/index.nginx-debian.html
                            echo "Permissions after chown/chmod:"
                            sudo -n ls -la /var/www/html/index.nginx-debian.html || true

                            sudo -n chmod a+rx /var/www/html
                            echo "Directory permissions after chmod a+rx:"
                            sudo -n ls -la /var/www/ | grep html || true

                            sudo -n systemctl daemon-reload
                            sudo -n systemctl restart nginx
                            echo "Nginx service status after restart:"
                            sudo -n systemctl status nginx --no-pager || true

                            echo "✅ AWS deployment completed successfully!"
                        '''
                    )
                ])
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo "🚀 Deploying to Azure..."
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'AZURE_VM',
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'index-azure.html',
                                removePrefix: '',
                                remoteDirectory: '/tmp'
                            )
                        ],
                        verbose: true,
                        failOnError: true,
                        execCommand: '''
                            set -e
                            echo "Starting Azure deployment..."
                            sudo -n mkdir -p /var/www/html
                            echo "Permissions of /var/www/html before move:"
                            sudo -n ls -la /var/www/ | grep html || true
                            sudo -n ls -la /var/www/html || true

                            sudo -n mv /tmp/index-azure.html /var/www/html/index.nginx-debian.html
                            echo "File moved. Permissions of index.nginx-debian.html after move:"
                            sudo -n ls -la /var/www/html/index.nginx-debian.html || true

                            sudo -n chown www-data:www-data /var/www/html/index.nginx-debian.html
                            sudo -n chmod 644 /var/www/html/index.nginx-debian.html
                            echo "Permissions after chown/chmod:"
                            sudo -n ls -la /var/www/html/index.nginx-debian.html || true

                            sudo -n chmod a+rx /var/www/html
                            echo "Directory permissions after chmod a+rx:"
                            sudo -n ls -la /var/www/ | grep html || true

                            sudo -n systemctl daemon-reload
                            sudo -n systemctl restart nginx
                            echo "Nginx service status after restart:"
                            sudo -n systemctl status nginx --no-pager || true

                            echo "✅ Azure deployment completed successfully!"
                        '''
                    )
                ])
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

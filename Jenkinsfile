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
                                echo "✅ AWS deployment completed!"
                            '''
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
                                echo "✅ Azure deployment completed!"
                            '''
                        )
                    ],
                    verbose: true
                )
            ])
        }
    }
}

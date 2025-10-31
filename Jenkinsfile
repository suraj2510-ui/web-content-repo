// Jenkinsfile for Web Content CD
pipeline {
    agent any

    environment {
        // Path where Nginx serves files on the target servers
        NGINX_HTML_PATH = "/var/www/html/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out web content from GitHub...'
                // Pulls code from your GitHub repo
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo 'Deploying to AWS App Machine...'
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE', // Must match Jenkins SSH config name
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    removePrefix: '',
                                    remoteDirectory: NGINX_HTML_PATH,
                                    execCommand: """
                                        echo "Deploying AWS site..."
                                        sudo mv ${NGINX_HTML_PATH}index-aws.html ${NGINX_HTML_PATH}index.html
                                        sudo chown www-data:www-data ${NGINX_HTML_PATH}index.html
                                        sudo systemctl restart nginx
                                        echo "✅ AWS deployment complete."
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
                echo 'Deploying to Azure VM...'
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM', // Must match Jenkins SSH config name
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    removePrefix: '',
                                    remoteDirectory: NGINX_HTML_PATH,
                                    execCommand: """
                                        echo "Deploying Azure site..."
                                        sudo mv ${NGINX_HTML_PATH}index-azure.html ${NGINX_HTML_PATH}index.html
                                        sudo chown www-data:www-data ${NGINX_HTML_PATH}index.html
                                        sudo systemctl restart nginx
                                        echo "✅ Azure deployment complete."
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
                echo 'Verifying Nginx content on both servers...'
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
            echo "Pipeline finished."
        }
        success {
            echo '✅ Deployment successful on both environments!'
        }
        failure {
            echo '❌ Deployment failed, check Jenkins logs for details.'
        }
    }
}

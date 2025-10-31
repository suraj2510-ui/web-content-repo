// Jenkinsfile for Web Content CD (Fixed Permissions + Clean Deployment)
pipeline {
    agent any

    environment {
        NGINX_HTML_PATH = "/var/www/html/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out web content from GitHub...'
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo 'Deploying to AWS App Machine...'
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    removePrefix: '',
                                    remoteDirectory: '/tmp/deploy', // ✅ Upload to writable temp directory
                                    execCommand: """
                                        echo "Deploying AWS site..."
                                        sudo mkdir -p ${NGINX_HTML_PATH}
                                        sudo rm -rf ${NGINX_HTML_PATH}*
                                        sudo cp /tmp/deploy/index-aws.html ${NGINX_HTML_PATH}index.html
                                        sudo chown -R www-data:www-data ${NGINX_HTML_PATH}
                                        sudo chmod -R 755 ${NGINX_HTML_PATH}
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
                            configName: 'AZURE_VM',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    removePrefix: '',
                                    remoteDirectory: '/tmp/deploy', // ✅ Upload to writable temp directory
                                    execCommand: """
                                        echo "Deploying Azure site..."
                                        sudo mkdir -p ${NGINX_HTML_PATH}
                                        sudo rm -rf ${NGINX_HTML_PATH}*
                                        sudo cp /tmp/deploy/index-azure.html ${NGINX_HTML_PATH}index.html
                                        sudo chown -R www-data:www-data ${NGINX_HTML_PATH}
                                        sudo chmod -R 755 ${NGINX_HTML_PATH}
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

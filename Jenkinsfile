// Jenkinsfile for Web Content Continuous Deployment
pipeline {
    agent any

    environment {
        // Nginx HTML file path on target servers
        NGINX_HTML_PATH = "/var/www/html/"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out source code from GitHub..."
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Test SSH Connection - AWS') {
            steps {
                echo "Testing SSH connectivity to AWS App Machine..."
                sh "ssh -o StrictHostKeyChecking=no aws-app 'hostname'"
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                echo "Deploying web content to AWS App Machine..."
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    removePrefix: '',
                                    remoteDirectory: '/home/ubuntu',   // Upload to writable directory
                                    execCommand: """
                                        sudo mv /home/ubuntu/index-aws.html ${NGINX_HTML_PATH}index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "Nginx restarted on AWS App Machine."
                                        sudo systemctl status nginx --no-pager
                                    """,
                                    flatten: true,
                                    makeEmptyDirs: false
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
                echo "Testing SSH connectivity to Azure VM..."
                sh "ssh -o StrictHostKeyChecking=no azure-vm 'uptime'"
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo "Deploying web content to Azure VM..."
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    removePrefix: '',
                                    remoteDirectory: '/home/azureuser',   // Upload to writable directory
                                    execCommand: """
                                        sudo mv /home/azureuser/index-azure.html ${NGINX_HTML_PATH}index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        echo "Nginx restarted on Azure VM."
                                        sudo systemctl status nginx --no-pager
                                    """,
                                    flatten: true,
                                    makeEmptyDirs: false
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
            echo "Pipeline finished."
        }
        success {
            echo '✅ Deployment successful to AWS and Azure!'
        }
        failure {
            echo '❌ Deployment failed — check the console logs for details.'
        }
    }
}

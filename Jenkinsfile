pipeline {
    agent any

    environment {
        NGINX_HTML_PATH = "/var/www/html/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Test SSH Connection - AWS') {
            steps {
                sh "ssh aws-app 'hostname'"
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    remoteDirectory: NGINX_HTML_PATH,
                                    execCommand: """
                                        sudo mv ${NGINX_HTML_PATH}index-aws.html ${NGINX_HTML_PATH}index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        sudo systemctl status nginx --no-pager
                                    """
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
                sh "ssh azure-vm 'uptime'"
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    remoteDirectory: NGINX_HTML_PATH,
                                    execCommand: """
                                        sudo mv ${NGINX_HTML_PATH}index-azure.html ${NGINX_HTML_PATH}index.nginx-debian.html
                                        sudo systemctl restart nginx
                                        sudo systemctl status nginx --no-pager
                                    """
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
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed, check logs.'
        }
    }
}

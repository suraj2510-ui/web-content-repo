// Jenkinsfile for Web Content CD
pipeline {
    agent any

    environment {
        # Define the path where the Nginx HTML files are on the target servers
        NGINX_HTML_PATH = "/var/www/html/"
    }

    stages {
        stage('Checkout Code') {
            steps {
                # Pulls the code from the configured GitHub repository
                git branch: 'main', url: 'https://github.com/suraj2510-ui/web-content-repo.git'
            }
        }

        stage('Deploy to AWS App Machine') {
            steps {
                script {
                    # Transfer index-aws.html to AWS App Machine
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AWS_APP_MACHINE', # Name configured in Jenkins system settings
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-aws.html',
                                    removePrefix: '',
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

        stage('Deploy to Azure VM') {
            steps {
                script {
                    # Transfer index-azure.html to Azure VM
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'AZURE_VM', # Name configured in Jenkins system settings
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index-azure.html',
                                    removePrefix: '',
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

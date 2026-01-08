pipeline {
    agent {
        docker {
            image 'mgopi1982/aws-infra-provisioner:v1'
            // We run as root to avoid permission issues with the workspace
            args '-u root' 
        }
    }

    environment {
        // IDs must match exactly what you created in Jenkins Credentials
        AWS_CREDS    = credentials('aws-credentials-id') 
        VAULT_PASS   = credentials('ansible-vault-pass-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/meesagopi25/DevOps-Projects.git'
            }
        }

        stage('Provision EC2') {
            steps {
                // We use withCredentials to safely pass the AWS keys to Ansible
                withCredentials([
                    usernamePassword(credentialsId: 'aws-credentials-id', 
                                     passwordVariable: 'AWS_SECRET_ACCESS_KEY', 
                                     usernameVariable: 'AWS_ACCESS_KEY_ID'),
                    file(credentialsId: 'ansible-vault-pass-id', 
                         variable: 'VAULT_FILE')
                ]) {
                    sh """
                    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                    export AWS_DEFAULT_REGION=us-east-1
                    
                    ansible-playbook provision-ec2.yml \
                        --vault-password-file ${VAULT_FILE} \
                        -e "aws_access_key=${AWS_ACCESS_KEY_ID}" \
                        -e "aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

pipeline {
    agent {
        docker {
            image 'mgopi1982/aws-infra-provisioner:v1'
            // Using args to ensure the container has permissions to the workspace
            args '-u root'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Ensure your repo URL and branch are correct
                git branch: 'main', url: 'https://github.com/meesagopi25/DevOps-Projects.git'
            }
        }

        stage('Provision EC2') {
            steps {
                script {
                    // This block maps your Jenkins credentials to variables
                    // Replace 'aws-credentials-id' with the ACTUAL ID in your Jenkins Credential store
                    withCredentials([
                        usernamePassword(credentialsId: 'aws-credentials-id', 
                                         passwordVariable: 'AWS_SECRET_ACCESS_KEY', 
                                         usernameVariable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'ansible-vault-password', 
                               variable: 'VAULT_PASS')
                    ]) {
                        sh """
                        # Create temporary vault password file
                        echo "\$VAULT_PASS" > .vault_pass
                        
                        # Set AWS Environment variables for the session
                        export AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=us-east-1
                        
                        ansible-playbook provision.yml \
                            -e "@dev.yaml" \
                            -e "@secrets.yaml" \
                            --vault-password-file .vault_pass
                        
                        # Remove password file immediately after use
                        rm .vault_pass
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Infrastructure provisioned successfully!"
        }
        cleanup {
            // cleanWs() must stay inside the agent context to work
            cleanWs()
        }
    }
}

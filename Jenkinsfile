pipeline {
    agent {
        docker {
            image 'mgopi1982/aws-infra-provisioner:v1'
            args '-u root' 
        }
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/meesagopi25/DevOps-Projects.git'
            }
        }

        stage('Provision Infrastructure') {
            steps {
                // We only need to pull the Vault Password from Jenkins
                withCredentials([string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]) {
                    sh """
                    # 1. Create a temporary password file for Ansible to read
                    echo "\$VAULT_PASS" > .vault_pass
                    
                    # 2. Run the playbook. 
                    # Ansible will automatically decrypt secrets.yaml using the password file.
                    ansible-playbook ec2-provision.yml \
                        -e "@dev.yaml" \
                        -e "@secrets.yaml" \
                        --vault-password-file .vault_pass
                    
                    # 3. Securely remove the password file
                    rm -f .vault_pass
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean workspace to ensure no sensitive files remain
            cleanWs()
        }
    }
}

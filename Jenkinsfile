pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: ansible-worker
    image: mgopi1982/aws-infra-provisioner:v1
    command: ["cat"]
    tty: true
"""
        }
    }

    environment {
        VAULT_PASS = credentials('ansible-vault-password')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Ansible Dry Run') {
            steps {
                container('ansible-worker') {
                    script {
                        sh 'echo "$VAULT_PASS" > .vault_pass'
                        // --check: Simulates the run
                        // --diff: Shows what changes would be made
                        sh """
                        ansible-playbook provision.yml \
                            -e "@dev.yaml" -e "@secrets.yaml" \
                            --vault-password-file .vault_pass \
                            --check --diff
                        """
                        sh 'rm .vault_pass'
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: "Dry run successful. Do you want to proceed with actual provisioning?", ok: "Deploy"
            }
        }

        stage('Provision EC2') {
            steps {
                container('ansible-worker') {
                    script {
                        sh 'echo "$VAULT_PASS" > .vault_pass'
                        sh """
                        ansible-playbook provision.yml \
                            -e "@dev.yaml" -e "@secrets.yaml" \
                            --vault-password-file .vault_pass
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            container('ansible-worker') { sh 'rm -f .vault_pass' }
        }
    }
}

parameters {
  choice(name: 'choice', choices: ['Plan', 'Apply', 'Destroy', 'State', 'Import'], description: 'Select Terraform Action')
  string(name: 'ENVIRONMENT', description: 'terraform, dev, sbx')
  string(name: 'Arguments', description: 'Type the Argument')
}

pipeline {
  agent any
  options {
    ansiColor('css')
  }
  environment {
    // Define environment variables for Azure credentials
    ARM_SUBSCRIPTION_ID = credentials('SUBSCRIPTION_ID')
    ARM_TENANT_ID = credentials('TENANT_ID')
    ARM_CLIENT_ID = credentials('CLIENT_ID')
    ARM_CLIENT_SECRET = credentials('CLIENT_SECRET')
    BACKEND_CONFIG_FILE = 'backend.tf'
     SSH_KEY = credentials('docker-host-keys') 
        REMOTE_HOST = 'root'
        TERRAFORM_PATH = '/usr/local/bin/terraform'
  }
  stages {
    stage('Checkout') {
      steps {
        cleanWs()
        echo 'Checking out code from Git'
        checkout scmGit(branches: [ [name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_credentials', url: 'https://github.com/git01h/terraform-backend.git']])
      }
      }
    stage('Execute Terraform Commands on Remote') {
            steps {
                script {
                    sshagent(['docker-host-keys']) {
                        // Modify the following line based on your specific Terraform commands
                        sh 'ssh -v -o StrictHostKeyChecking=no -l root 172.25.10.139  black -a'

                    }
                }
            }
        }
    
    stage('Terraform init') {
      steps {
        script {
          sh "terraform init -backend-config=key=${params.ENVIRONMENT}.tfstate"

        }
      }
    }
    stage('terraform validate') {
      steps {
        script {
          sh 'terraform validate'
        }
      }
    }
    stage('Terraform Plan') {
      when {

        expression {
          choice == 'Plan' || 'Apply' || 'Destroy' && currentBuild.resultIsBetterOrEqualTo('SUCCESS')
        }
      }
      steps {
        script {
          //ENVIRONMENT parameter to select the appropriate .tfvars file
          def tfvarsFile = "${params.ENVIRONMENT}.tfvars"
          sh "terraform plan -var-file=${tfvarsFile} -out=plan.out"
        }
      }
    }

    stage(' Terraform Apply') {
      when {

        expression {
          choice == 'Apply' && currentBuild.resultIsBetterOrEqualTo('SUCCESS')
        }
      }
      steps {
        script {
          input "Please approve to proceed with Apply"
          // Run Terraform apply using the saved plan file
          sh 'terraform apply "plan.out"'
        }
      }
    }
    stage('terraform destroy') {
      when {

        expression {
          choice == 'Destroy' && currentBuild.resultIsBetterOrEqualTo('SUCCESS')
        }
      }
      steps {
        script {
          input "Please approve to proceed with Destroy"
          sh 'terraform destroy --auto-approve'
        }
      }
    }
    stage('Terraform Import') {
      when {
        expression {
          choice == 'Import' && params.Arguments != ""
        }
      }
      steps {
        script {
          sh "terraform import ${params.Arguments}"
        }
      }
    }
    //if (choice == 'State'){
    //terraform_state_option =params.Arguments.split()[0]

    stage('Terraform state') {
      when {
        expression {
          choice == 'State' && params.Arguments != " "
        }
      }
      steps {
        script {
          def terraformStateAction = params.Arguments.split(' ')[0]
          def terraformStateResource = params.Arguments.split(' ')[1]
          stage(" ${terraformStateAction}")

          if (terraformStateAction == 'list') {
            sh 'terraform state list'
          } else if (terraformStateAction == 'show') {
            sh "terraform state show '${terraformStateResource}'"
          } else if (terraformStateAction == 'rm') {
            sh 'terraform state list'
            input 'Please confirm to proceed with Terraform State Remove'
            sh "terraform state rm '${terraformStateResource}'"
          } else {
            error "Invalid terraformStateAction: ${terraformStateAction}. Supported actions are 'list', 'show', and 'rm'."
          }
        }

      }
    }
  }
}

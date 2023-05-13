pipeline {
  agent any
  parameters {
    string(name: 'DB_USERNAME', defaultValue: '', description:'Provide DB username')
	password(name: 'DB_PASSWORD', defaultValue: '', description: 'Provide DB password')
  }
   // Make sure these credentials would have been configured in Jenkins with their respective credential IDs jenkins-aws-secret-key-id and jenkins-aws-secret-access-key.
   
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }
  stages 
  {
    stage('TerraformInit'){
        steps {
            sh "terraform init -input=false"
        }
    }
    
    stage('TerraformApply'){
        steps {
            script{                    
                sh 'terraform apply -var "db_username=${DB_USERNAME}" -var "db_password=${DB_PASSWORD}" -auto-approve'
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
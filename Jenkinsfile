pipeline {
    agent any
    environment {
        AWS_ACCESS_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        AWS_DEFAULT_REGION = "eu-west-3"
    }
    stages {
        stage('Destroy Infrastructure') {
            steps {
                script {
                    dir('EKS') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
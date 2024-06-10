pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        AWS_DEFAULT_REGION = "eu-west-3"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/prkltos/terraform-jenkins-eks.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform plan'
                    }
                    // input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('EKS') {
                        sh 'terraform $action apply --auto-approve'
                }
            }
        }
    }
    stage('Deploying Application') {
        steps{
            script{
                dir('EKS/ConfigurationFiles') {
                    sh 'aws eks update-kubeconfig --name my-eks-cluster'
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }
    stage('Destroy Infrastructure') {
        when {
            expression { params.DESTROY_INFRA }
        }
        steps {
            script {
                dir('EKS') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
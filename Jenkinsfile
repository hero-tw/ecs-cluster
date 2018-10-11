pipeline {
  agent {
    node {
      label 'master'
    }
  }
  environment {
    AWS_KEY = credentials('aws-keys')
  }
  stages {
    stage('checkout') {
      steps {
        checkout scm
        sh 'docker pull hashicorp/terraform:light'
      }
    }
    stage('init') {
      steps {
        sh 'docker run -w /app -e AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW -e AWS_ACCESS_KEY_ID=$AWS_KEY_USR -v `pwd`:/app hashicorp/terraform:light init'
      }
    }
    stage('plan') {
      steps {
        sh 'docker run -w /app -e AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW -e AWS_ACCESS_KEY_ID=$AWS_KEY_USR -v `pwd`:/app hashicorp/terraform:light plan'
      }
    }
    stage('approval') {
      options {
        timeout(time: 1, unit: 'HOURS')
      }
      steps {
        input 'approve the plan to proceed and apply'
      }
    }
    stage('apply') {
      steps {
        sh 'docker run -w /app -e AWS_SECRET_ACCESS_KEY=$AWS_KEY_PSW -e AWS_ACCESS_KEY_ID=$AWS_KEY_USR -v `pwd`:/app hashicorp/terraform:light apply -auto-approve'
        cleanWs()
      }
    }

  }
}
pipeline {
  agent any
  stages {
    stage('ttt') {
      steps {
        sh 'docker build . -t k8s-debian-test'
      }
    }

    stage('') {
      steps {
        sh '''# Build the image
$(aws ecr get-login --region eu-west-1 --profile global --no-include-email)
docker build . -t k8s-debian-test'''
      }
    }

  }
}
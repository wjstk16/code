pipeline {
  agent any
  stages {
    stage('ttt') {
      steps {
        sh '''ssh host -t "docker ps"

#docker build . -t k8s-debian-test'''
      }
    }

    stage('error') {
      steps {
        sh 'ls'
      }
    }

  }
}
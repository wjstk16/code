pipeline {
  agent any
  stages {
    stage('ttt') {
      steps {
        sh '''docker ps

#ssh host -t "docker ps"

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
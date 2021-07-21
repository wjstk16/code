def podLabel = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: podLabel, containers: [
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'tools', image: 'argoproj/argo-cd-ci-builder:v1.0.1', command: 'cat', ttyEnabled: true),
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node(label) {
    def myRepo
    stage('Checkout') {
      myRepo = checkout scm
    }

    def gitCommit = myRepo.GIT_COMMIT
    def shortGitCommit = "${gitCommit[0..7]}"
    def imageTag = shortGitCommit

    stage('Image Build') {
      container('docker') {
        sh "docker build . -t kangwoo/hello-go:${imageTag}"
      }
    }

    stage('Image Push') {
      container('docker') {
        sh "docker push kangwoo/hello-go:${imageTag}"
      }
    }

    stage('Deploy to dev') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'my-git', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PWD')]) {
          container('tools') {
            sh "git clone https://${GIT_USER}:${GIT_PWD}@github.com/kangwoo/hello-go-deploy.git"
            sh "git config --global user.email '${GIT_USER}@mycompany.com'"

            dir("hello-go-deploy") {
              sh "cd ./overlays/dev && kustomize edit set image kangwoo/hello-go:${imageTag}"
              sh "git commit -am 'Publish new version ${imageTag} to dev' && git push || echo 'no changes'"
            }
          }
        }
      }
    }

  }
}

node('jenkins-jnlp') {
    env.MVN_HOME = "${tool 'Maven'}"
    env.PATH="${env.MVN_HOME}/bin:${env.PATH}"

    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            if (env.BRANCH_NAME != 'master') {
                build_tag = "${env.BRANCH_NAME}-${build_tag}"
            }
        }
    }
    stage('Compile') {
        echo "2.Compile SpringBoot App Stage"
        sh "mvn clean package -Dmaven.test.skip=true"
    }
    stage('Build') {
        echo "3.Build Docker Image Stage"
        sh "docker build -t wjstk16/test:${build_tag} ."
    }
    stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sh "docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
            sh "docker push wjstk16/test:${build_tag}"
        }
    }
    stage('Deploy') {
        echo "5. Deploy To K8S Cluster Stage"
        sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
        sh "kubectl apply -f k8s.yaml --record"
    }
}

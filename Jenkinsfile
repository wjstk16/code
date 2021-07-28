pipeline {
    agent {
        node {
            label 'testing'
        }
    }
    
    stages {       
        stage('Prepare') {
            steps {
                checkout([$class: 'GitSCM',
                branches: [[name: "origin\master"]],
                doGenerateSubmoduleConfigurations: false,
                submoduleCfg: [],
                userRemoteConfigs: [[
                    url: 'ssh:\\git@git.example.com\argocd-test\argocd-test.git']]
                ])
            }
        }
        stage ('Docker_Build') {
            steps {
                \\ Build the docker image
                sh'''
                    # Build the image
                    $(aws ecr get-login --region eu-west-1 --profile global --no-include-email)
                    docker build . -t k8s-debian-test
                '''
            }
        }
        
        stage ('Deploy_K8S') {
             steps {
                     withCredentials([string(credentialsId: "jenkins-argocd-deploy", variable: 'ARGOCD_AUTH_TOKEN')]) {
                        sh '''
                        ARGOCD_SERVER="argocd-prod.example.com"
                        APP_NAME="debian-test-k8s"
                        CONTAINER="k8s-debian-test"
                        REGION="eu-west-1"
                        AWS_ACCOUNT="$ACCOUNT_NUMBER"
                        AWS_ENVIRONMENT="staging"

                        $(aws ecr get-login --region $REGION --profile $AWS_ENVIRONMENT --no-include-email)
                        
                        # Deploy image to ECR
                        docker tag $CONTAINER:latest $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com\$CONTAINER:latest
                        docker push $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com\$CONTAINER:latest
                        IMAGE_DIGEST=$(docker image inspect $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com\$CONTAINER:latest -f '{{join .RepoDigests ","}}')
                        # Customize image 
                        ARGOCD_SERVER=$ARGOCD_SERVER argocd --grpc-web app set $APP_NAME --kustomize-image $IMAGE_DIGEST
                        
                        # Deploy to ArgoCD
                        ARGOCD_SERVER=$ARGOCD_SERVER argocd --grpc-web app sync $APP_NAME --force
                        ARGOCD_SERVER=$ARGOCD_SERVER argocd --grpc-web app wait $APP_NAME --timeout 600
                        '''
               }
            }
        }
    }
}

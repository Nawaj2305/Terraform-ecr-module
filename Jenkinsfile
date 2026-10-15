<<<<<<< HEAD

pipeline {
    agent any

    environment {
        AWS_REGION       = 'us-east-1'
        AWS_ACCOUNT_ID   = '085831229262'
        ECR_REPOSITORY   = 'my-ecs-app'
        AWS_CREDENTIALS = 'aws-ecr-credentials'
        ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Check Dockerfile') {
            steps {
                script {
                    if (!fileExists('src/dockerfile')) {
                        error 'src/dockerfile not found!'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ./src

                    docker tag \
                      ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ${ECR_REPOSITORY}:latest
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${AWS_CREDENTIALS}"
                ]]) {
                    sh '''
                        aws sts get-caller-identity

                        aws ecr get-login-password \
                          --region ${AWS_REGION} \
                        | docker login \
                          --username AWS \
                          --password-stdin \
                          ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    docker tag \
                      ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker tag \
                      ${ECR_REPOSITORY}:latest \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:latest

                    docker push \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker push \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully pushed to AWS ECR!'
        }

        failure {
            echo 'Pipeline failed. Check the Jenkins console output.'
        }
    }
}
=======

pipeline {
    agent any

   environment {
        AWS_REGION       = 'us-east-1'
        AWS_ACCOUNT_ID   = '085831229262'
        ECR_REPOSITORY   = 'my-ecs-app'
        AWS_CREDENTIALS = 'aws-ecr-credentials'
        ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Check Dockerfile') {
            steps {
                script {
                    if (!fileExists('src/Dockerfile')) {
                        error 'src/Dockerfile not found!'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ./src

                    docker tag \
                      ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ${ECR_REPOSITORY}:latest
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${AWS_CREDENTIALS}"
                ]]) {
                    sh '''
                        aws sts get-caller-identity

                        aws ecr get-login-password \
                          --region ${AWS_REGION} \
                        | docker login \
                          --username AWS \
                          --password-stdin \
                          ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    docker tag \
                      ${ECR_REPOSITORY}:${BUILD_NUMBER} \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker tag \
                      ${ECR_REPOSITORY}:latest \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:latest

                    docker push \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${BUILD_NUMBER}

                    docker push \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:latest
                '''
            }
        }
    }


    post {
        success {
            withCredentials([
                string(
                    credentialsId: 'slack-webhook',
                    variable: 'SLACK_WEBHOOK'
                )
            ]) {
                sh '''
                    curl -fsS -X POST \
                    -H "Content-Type: application/json" \
                    --data "$(jq -n \
                        --arg job "$JOB_NAME" \
                        --arg build "$BUILD_NUMBER" \
                        --arg image "$ECR_REGISTRY/$ECR_REPOSITORY:$BUILD_NUMBER" \
                        --arg cluster "$ECS_CLUSTER" \
                        --arg service "$ECS_SERVICE" \
                        --arg url "$BUILD_URL" \
                        '{
                        attachments: [{
                            color: "good",
                            title: "Jenkins ECS Deployment Successful",
                            text: ("Project: " + $job +
                            "\\nBuild: #" + $build +
                            "\\nImage: " + $image +
                            "\\nECS Cluster: " + $cluster +
                            "\\nECS Service: " + $service +
                            "\\nBuild URL: " + $url)
                        }]
                        }')" \
                    "$SLACK_WEBHOOK"
                '''
            }
        }

        failure {
            withCredentials([
                string(
                    credentialsId: 'slack-webhook',
                    variable: 'SLACK_WEBHOOK'
                )
            ]) {
                sh '''
                    curl -fsS -X POST \
                    -H "Content-Type: application/json" \
                    --data "$(jq -n \
                        --arg job "$JOB_NAME" \
                        --arg build "$BUILD_NUMBER" \
                        --arg url "$BUILD_URL" \
                        '{
                        attachments: [{
                            color: "danger",
                            title: "Jenkins Pipeline Failed",
                            text: ("Project: " + $job +
                            "\\nBuild: #" + $build +
                            "\\nStatus: FAILURE" +
                            "\\nBuild URL: " + $url)
                        }]
                        }')" \
                    "$SLACK_WEBHOOK"
                '''
            }
        }

        always {
            echo 'Pipeline execution finished.'
            sh 'docker image prune -f || true'
        }
    }
}
>>>>>>> 46ffcc7 (added slack notification code)

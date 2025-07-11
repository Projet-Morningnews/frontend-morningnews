pipeline {
    agent any

    environment {
        PROJECT = "frontend-morningnews"
        APP_NAME = "morningnews-frontend-lacapsule"
        BRANCH_NAME = scm.branches[0].name
        IMAGE_TAG = "${APP_NAME}-${BRANCH_NAME}:${BUILD_NUMBER}"
        REGISTRY = "docker.io"
        DOCKER_IMAGE = "${REGISTRY}/phuulia/${APP_NAME}-${BRANCH_NAME}:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                script {
                    cp .env.example .env
                    sed -i "s#^\(NEXT_PUBLIC_BACKURL=\).*\$#\1${BACKEND_URL}#" ./.env
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push dockerhub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'}
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('OpenShift Login') {
            steps {
                withCredentials([
                    string(credentialsId: 'openshift-token', variable: 'TOKEN'),
                    string(credentialsId: 'openshift-api-url', variable: 'API_URL')
                ]) {
                    sh '''
                        echo "Checking if deployment $APP_NAME exists in project $PROJECT..."
                        if oc get deployment $APP_NAME -n $PROJECT --token=$TOKEN --server=$API_URL > /dev/null 2>&1; then
                            echo "Deployment exists. Logging in..."
                            oc login --token=$TOKEN --server=$API_URL
                        else
                            echo "Deployment not found. Skipping login."
                            exit 0
                        fi
                    '''
                }
            }
        }

        stage('Update OpenShift Image') {
            steps {
                script {
                    sh '''
                        echo "Checking if deployment $APP_NAME exists in project $PROJECT..."
                        if oc get deployment $APP_NAME -n $PROJECT > /dev/null 2>&1; then
                            echo "Updating image for deployment $APP_NAME..."
                            oc project $PROJECT
                            oc set image deployment/$APP_NAME $APP_NAME=$DOCKER_IMAGE --record
                        else
                            echo "Deployment not found. Skipping image update."
                        fi
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Successfully deployed image ${DOCKER_IMAGE} to OpenShift"
        }
        failure {
            echo "Build failed!"
        }
    }
}
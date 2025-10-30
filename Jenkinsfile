pipeline {
  agent any

  environment {
    DOCKERHUB_CRED = 'dockerhub-creds'      // Create this in Jenkins (username/password)
    IMAGE = '<DOCKERHUB_USER>/dockerproject' // replace <DOCKERHUB_USER>
    KUBE_NAMESPACE = 'default'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install & Test') {
      steps {
        sh 'npm install'
        sh 'bash scripts/test.sh'
      }
    }

    stage('Build Image') {
      steps {
        sh "docker build -t ${IMAGE}:$BUILD_NUMBER ."
        sh "docker tag ${IMAGE}:$BUILD_NUMBER ${IMAGE}:latest"
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CRED}", usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh 'echo $DH_PASS | docker login --username $DH_USER --password-stdin'
          sh "docker push ${IMAGE}:$BUILD_NUMBER"
          sh "docker push ${IMAGE}:latest"
          sh 'docker logout'
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        // assumes kubectl already configured on Jenkins agent (or use kubeconfig credential)
        sh "kubectl set image deployment/dockerproject-deployment dockerproject=${IMAGE}:latest -n ${KUBE_NAMESPACE} || kubectl apply -f k8s/"
        sh "kubectl rollout status deployment/dockerproject-deployment -n ${KUBE_NAMESPACE}"
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}

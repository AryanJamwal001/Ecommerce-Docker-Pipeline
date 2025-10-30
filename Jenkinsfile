pipeline {
  agent any

  environment {
    DOCKERHUB_CRED = 'dockerhub-creds'      
    IMAGE = 'aryanjamwal001/dockerproject'   // apna DockerHub username likh
    KUBE_NAMESPACE = 'default'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Test') {
      steps {
        bat 'npm install'
        // bat 'npm test'  // optional
      }
    }

    stage('Build Image') {
      steps {
        bat "docker build -t %IMAGE%:%BUILD_NUMBER% ."
        bat "docker tag %IMAGE%:%BUILD_NUMBER% %IMAGE%:latest"
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CRED}", usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          bat 'echo %DH_PASS% | docker login --username %DH_USER% --password-stdin'
          bat "docker push %IMAGE%:%BUILD_NUMBER%"
          bat "docker push %IMAGE%:latest"
          bat 'docker logout'
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        bat "kubectl set image deployment/dockerproject-deployment dockerproject=%IMAGE%:latest -n %KUBE_NAMESPACE% || kubectl apply -f k8s/"
        bat "kubectl rollout status deployment/dockerproject-deployment -n %KUBE_NAMESPACE%"
      }
    }
  }

  post {
    always {
      echo "✅ Pipeline finished successfully!"
    }
  }
}

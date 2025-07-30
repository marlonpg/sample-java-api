// Jenkinsfile

pipeline {
    // 1. Define the build agent. This must match the label in jenkins-values.yaml
    agent {
        label 'jenkins-maven-agent'
    }

    // 2. Environment variables used throughout the pipeline
    environment {
        // The name of the Docker image we will build
        IMAGE_NAME = "sample-java-api"
        // The path to the GENERIC application's Helm chart in the platform repo
        HELM_CHART_PATH = "helm/charts/generic-app"
        // The Helm release name for the deployment
        HELM_RELEASE_NAME = "sample-java-api"
    }

    stages {
        // 3. Stage to run tests. The pipeline will fail here if tests fail.
        stage('Run Tests') {
            steps {
                // Use the 'maven' container from our agent pod
                container('maven') {
                    sh 'mvn test'
                }
            }
        }

        // 4. Stage to compile the code and package it into a .jar file
        stage('Package Application') {
            steps {
                container('maven') {
                    // Skip tests since they already ran
                    sh 'mvn package -DskipTests'
                }
            }
        }

        // 5. Stage to build a Docker image
        stage('Build Docker Image') {
            steps {
                // Use the 'docker' container from our agent pod
                container('docker') {
                    // Build the image and tag it with the Jenkins BUILD_ID
                    sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_ID} ."
                }
            }
        }

        // 6. Stage to deploy the application using Helm
        stage('Deploy to Kubernetes') {
            steps {
                // Use the 'helm' container from our agent pod
                container('helm') {
                    // We need to check out the devops-platform repo to get the Helm chart
                    // This assumes your my-devops-platform project is also in a Git repo
                    // For this example, we'll use a placeholder URL.
                    // IMPORTANT: Replace this with the actual URL to your devops platform repo
                    git url: 'https://github.com/your-username/my-devops-platform.git', branch: 'main'

                    // Run the helm upgrade command
                    sh """
                        helm upgrade --install ${env.HELM_RELEASE_NAME} ./${env.HELM_CHART_PATH} \\
                             --namespace apps \\
                             --set image.repository=${env.IMAGE_NAME} \\
                             --set image.tag=${env.BUILD_ID} \\
                             --set image.pullPolicy=Never
                    """
                }
            }
        }
    }
}
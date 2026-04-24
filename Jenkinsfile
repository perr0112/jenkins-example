pipeline {
    agent any

    options {
        // Interdit le lancement de ce job 2 fois en même temps
        disableConcurrentBuilds()
        // dans un parallel: si l'un des thread échoue => stop
        parallelsAlwaysFailFast()
    }

    environment {
        IMAGE_NAME = "task-api"
        // All global variables here:
        // http://localhost:8080/job/groovy-proj/pipeline-syntax/globals
    }

    stages {
        stage("install") {
            steps {
                sh 'npm ci'
            }
        }
        // Lancer le lint + les tests
        stage("Qualité") {
            parallel {

                stage("Lint") {
                    steps {
                        sh "npm run lint"
                    }
                }

                stage("Tests") {
                    steps {
                        sh "npm run test:coverage"
                    }
                }

            }
        }

        // Build docker de cette image en utilisant le daemon de l'hôte
        stage("Build - Docker") {
            steps {
                // sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                sh '''
                docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage("Deploy") {
            steps {
                sh 'docker run -d -p 3002:3000 ${IMAGE_NAME}:${BUILD_NUMBER}'
            }
        }
    }
}
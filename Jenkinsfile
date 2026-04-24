pipeline {
    agent any

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
    }
}
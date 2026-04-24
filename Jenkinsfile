pipeline {
    agent any

    stages {
        stage("install") {
            steps {
                sh 'npm ci'
            }
        }
        // Lancer le lint + les tests
        stage("lint") {
            steps {
                sh 'npm run lint'
            }
        }

        stage("tests") {
            steps {
                sh 'npm run test'
            }
        }
    }
}
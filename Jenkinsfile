pipeline {
    agent any
    
    environment {
        SONARQUBE_SERVER = 'sonarqube 9'
        MAVEN_HOME = tool name: 'mvn', type: 'maven'
    }

    stages {
        stage('Checkout Código') {
            steps {
                git branch: 'atom', url: 'https://github.com/hkhcoder/vprofile-project.git'
            }
        }

        stage('Compilar y Testear') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package"
            }
        }

        stage('Análisis con SonarQube') {
            steps {
                withSonarQubeEnv(SONARQUBE_SERVER) {
                    sh "${MAVEN_HOME}/bin/mvn sonar:sonar"
                }
            }
        }

        
    }

    post {
        success {
            echo 'Pipeline completado con éxito'
        }
        failure {
            echo 'Pipeline fallido'
        }
    }
}

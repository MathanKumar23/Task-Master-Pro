pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MathanKumar23/Task-Master-Pro'
            }
        }
     stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
     stage('test') {
            steps {
                sh "mvn test"
            }
        }
     stage('tricy FS scan') {
            steps {
                sh "trivy fs --format table -o fs-report.html ."
            }
     }
    stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -X -Dsonar.projectKey=TaskMaster -Dsonar.projectName=TaskMaster -Dsonar.java.binaries=target'''
                }
            }
        }
    stage('Build Applicaion') {
            steps {
                sh "mvn package"
            }
        }
    stage('Build & Tag Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker build -t mathan/taskmaster:latest .'
                    }
                }
            }
        }
    stage('Scan Docker Image by Trivy') {
            steps {
                sh "trivy image --format table -o image-report.html mathan/taskmaster:latest"
            }
        }
    stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker push mathan/taskmaster:latest '
                    }
                }
            }
        }
    }
}

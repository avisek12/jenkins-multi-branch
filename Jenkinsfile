pipeline {
    agent { label "remotehost2" }

    environment {
        DOCKER_LOGIN = credentials('DOCKER_LOGIN')
        SONAR_LOGIN = credentials('sonar')
    }
        stages {
        stage('Git checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/avisek12/Jenkins-pipeline.git',
                    credentialsId: 'git-creds'
            }
        }
        
        stage('Verify Code') {
            steps {
                sh '''
                pwd
                ls -R
                '''
            }
        }
        
        stage('SonarQube Scan') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('sonarqube') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectName=sonar-avi -Dsonar.projectKey=sonar-avi -Dsonar.sources=."
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Docker Build') {
            steps {
                input message: 'Do you want to proceed?', ok: 'Approve',submitter: 'admin,devops-team'
                sh '''
                echo $DOCKER_LOGIN_PSW | docker login -u $DOCKER_LOGIN_USR --password-stdin
                '''
                sh 'docker --version'
                sh 'docker build -t jenkins-custom-image:v1 .'
            }
        }
        
        stage('Docker Deploy') {
            steps {
                sh '''
                echo $DOCKER_LOGIN_PSW | docker login -u $DOCKER_LOGIN_USR --password-stdin
                '''
                sh 'docker compose down'
                sh 'docker compose up -d'
            }
        }

        stage('CLEAN UP') {
            steps {
                sh '''
                rm -rf *
                '''
            }
        }
     }
     post {
       always {
        emailext(
            to: 'a.bhattachar0@gmail.com',
            subject: "Jenkins Build Notification: ${currentBuild.currentResult}",
            mimeType: 'text/html',
            body: """
            <html>
            <body style="font-family: Arial, sans-serif; background-color: #f4f6f8; padding: 20px;">
                <div style="max-width: 600px; margin: auto; background: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                    
                    <h2 style="color: #2c3e50; text-align: center;">
                        Jenkins Build Status
                    </h2>

                    <p style="font-size: 16px; color: #333;">
                        Hello,
                    </p>

                    <p style="font-size: 16px; color: #333;">
                        Your Jenkins job has completed with the following status:
                    </p>

                    <p style="font-size: 18px; font-weight: bold; color: ${currentBuild.currentResult == 'SUCCESS' ? '#27ae60' : '#e74c3c'};">
                        ${currentBuild.currentResult}
                    </p>

                    <p style="font-size: 16px; color: #333;">
                        <strong>Job Name:</strong> ${env.JOB_NAME} <br>
                        <strong>Build Number:</strong> #${env.BUILD_NUMBER}
                    </p>

                    <div style="text-align: center; margin: 20px 0;">
                        <a href="${env.BUILD_URL}" 
                           style="background-color: #3498db; color: #ffffff; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
                           View Build Details
                        </a>
                    </div>

                    <hr style="border: none; border-top: 1px solid #eee;">

                    <p style="font-size: 12px; color: #999; text-align: center;">
                        This is an automated message from Jenkins. Please do not reply.
                    </p>

                </div>
            </body>
            </html>
            """
        )
    }
 }
}

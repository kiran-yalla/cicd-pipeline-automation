// Jenkinsfile
// Sample declarative Jenkins pipeline demonstrating a typical enterprise
// build -> test -> deploy workflow with environment promotion and rollback.

pipeline {
    agent any

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
    }

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
        booleanParam(name: 'RUN_SMOKE_TESTS', defaultValue: true, description: 'Run smoke tests after deploy')
    }

    environment {
        APP_NAME     = 'sample-platform-service'
        ARTIFACT_DIR = 'build/artifacts'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building ${env.APP_NAME}..."
                sh './scripts/build.sh'
            }
        }

        stage('Unit Tests') {
            steps {
                sh './scripts/run-tests.sh'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/test-results/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh "tar -czf ${ARTIFACT_DIR}/${APP_NAME}.tar.gz dist/"
                archiveArtifacts artifacts: "${ARTIFACT_DIR}/*.tar.gz", fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying to ${params.DEPLOY_ENV}..."
                sh "./scripts/deploy.sh ${params.DEPLOY_ENV}"
            }
        }

        stage('Smoke Tests') {
            when {
                expression { return params.RUN_SMOKE_TESTS }
            }
            steps {
                sh "./scripts/smoke-test.sh ${params.DEPLOY_ENV}"
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed - triggering rollback for non-dev environments.'
            script {
                if (params.DEPLOY_ENV != 'dev') {
                    sh "./scripts/rollback.sh ${params.DEPLOY_ENV}"
                }
            }
        }
        success {
            echo "Deployment to ${params.DEPLOY_ENV} completed successfully."
        }
    }
}


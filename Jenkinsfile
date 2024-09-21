@Library('my-shared-library') _

pipeline{
    agent any
    //agent { label 'Demo' }
    parameters{
        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        string(name: 'ImageName', description: "name of the docker build", defaultValue: 'javapp')
        string(name: 'ImageTag', description: "tag of the docker build", defaultValue: 'v1')
        string(name: 'DockerHubUser', description: "name of the Application", defaultValue: 'chowvishal')
    }
    stages{
        //Stage Name: It's labeled as 'Git Checkout', which clearly indicates its purpose.
        //when block ensures that this stage runs only when the params.action is set to 'create'.
        stage('Git Checkout'){
            when { expression {  params.action == 'create' } }
            steps{
                //The gitCheckout function pulls the code from the specified branch and repository.
                gitCheckout(
                    branch: "main",
                    url: "https://github.com/Vishal1996-210/Java_app_3.0.git"
                )
            }
        }
        stage('Unit Test maven'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    //Calls the mvnTest() function to run your tests.
                    mvnTest()
                }
            }
        }
        stage('Integration Test maven'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    mvnIntegrationTest()
                }
            }
        }
        stage('Static code analysis: Sonarqube'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    def SonarQubecredentialsId = 'sonarqube-api'
                    statiCodeAnalysis(SonarQubecredentialsId)
                }
            }
        }
        stage('Quality Gate Status Check : Sonarqube'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    def SonarQubecredentialsId = 'sonarqube-api'
                    QualityGateStatus(SonarQubecredentialsId)
                }
            }
        }
        stage('Maven Build : maven'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    mvnBuild()
                }
            }
        }
        stage('Docker Image Build'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    dockerBuild("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                }
            }
        }
        stage('Docker Image Scan: trivy '){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    dockerImageScan("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                }
            }
        }
        stage('Docker Image Push : DockerHub '){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    dockerImagePush("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                }
            }
        }   
        stage('Docker Image Cleanup : DockerHub '){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                    dockerImageCleanup("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                }
            }
        }      
    }
}

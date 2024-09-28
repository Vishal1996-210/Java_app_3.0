@Library('my-shared-library') _

pipeline{
    agent any
    //agent { label 'Demo' }
    parameters{
        choice(name: 'action', choices: 'create\nrollback', description: 'Create/rollback of the deployment')
        string(name: 'ImageName', description: "Name of the docker build", defaultValue: "kubernetes-configmap-reload")
        string(name: 'ImageTag', description: "Name of the docker build",defaultValue: "v1")
        string(name: 'AppName', description: "Name of the Application",defaultValue: "kubernetes-configmap-reload")
        string(name: 'docker_repo', description: "Name of docker repository",defaultValue: "chowvishal")
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
        // stage('Docker Image Scan: trivy '){
        //     when { expression {  params.action == 'create' } }
        //     steps{
        //         script{
        //             dockerImageScan("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
        //         }
        //     }
        // }
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
        stage("Ansible Setup") {
            when {
                expression { params.action == 'create' }
            }
            steps {
                sh 'ansible-playbook ${WORKSPACE}/Java_app_3.0/server_setup.yml'
            }
        }
        stage("Create deployment") {
            when {
                expression { params.action == 'create' }
            }
            steps {
                sh 'echo ${WORKSPACE}'
                sh 'kubectl create -f ${WORKSPACE}/Java_app_3.0/kubernetes-configmap.yml'
            }
        }
        stage ("wait_for_pods"){
            steps{
                sh 'sleep 300'
            }
        }
        stage("rollback deployment") {
            steps {	            	         	           
                sh """
                kubectl delete deploy ${params.AppName}
                kubectl delete svc ${params.AppName}
                """	       
            }
        }
    }
}

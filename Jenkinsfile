pipeline {
     agent any
     environment {
          dotnet = 'C:\\Program Files\\dotnet\\dotnet.exe'
     }
     stages {
          stage ('Checkout') {
               steps {
                    git credentialsId: 'azimifarbehzad', url: 'https://github.com/azimifarbehzad/SampleJenkinCI', branch: 'master'
               }
          }
          stage ('Restore PACKAGES') {
               steps {
                    bat 'dotnet restore'
               }
          }
          stage('Clean') {
               steps {
                    bat  'dotnet clean'
               }
          }
          stage('Build') {
               steps {
                    bat  'dotnet build --configuration Release'
               }
          }
           stage('Test') {
               steps {
                    bat  'dotnet test'
               }
          }
          // stage('Pack') {
          //      steps {
          //           bat  'dotnet pack --no-build --output nupkgs'
          //      }
          // }
          // stage('Publish') {
          //      steps {
          //           bat  "dotnet nuget push **\\nupkgs\\*.nupkg -k yourApiKey -s http://myserver/artifactory/api/nuget/nuget-internal-stable/com/sample"
          //      }
          // }
     }
}

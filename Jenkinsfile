pipeline {
agent any
environment {
dotnet = 'path\\to\\dotnet.exe'
}
stages {
stage ('Checkout') {
            steps {
                 git credentialsId: 'azimifarbehzad', url: 'https://github.com/azimifarbehzad/SampleJenkinCI',branch: 'master'
            }
}
stage ('Restore PACKAGES') {     
         steps {
             sh(script: "dotnet restore --configfile NuGet.Config")
          }
        }
stage('Clean') {
      steps {
            sh(script:  'dotnet clean')
       }
    }
stage('Build') {
     steps {
            sh(script:  'dotnet build --configuration Release')
      }
   }
stage('Pack') {
     steps {
           sh(script:  'dotnet pack --no-build --output nupkgs')
      }
   }
stage('Publish') {
      steps {
           sh(script:  "dotnet nuget push **\\nupkgs\\*.nupkg -k yourApiKey -s http://myserver/artifactory/api/nuget/nuget-internal-stable/com/sample")
       }
   }
 }
}

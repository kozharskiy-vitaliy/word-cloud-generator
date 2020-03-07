pipeline {
    agent {
        
        dockerfile {
            additionalBuildArgs  '-t jenkins-slave'
            args '--name jenkins-slave'

        }    
    }
    stages {
        stage('build') {
            steps {
                sh 'echo Hello'
            
            }
        
        }
    }
    
}

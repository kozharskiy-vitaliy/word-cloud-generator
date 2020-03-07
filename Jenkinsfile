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
                sh """
                    sleep 180
                    export PATH="\$PATH:${WORKSPACE}/bin"
                    sed -i 's/1.DEVELOPMENT/1.${BUILD_NUMBER}/g' ./rice-box.go
                    make
                    md5sum artifacts/*/word-cloud-generator* >artifacts/word-cloud-generator.md5
                    gzip artifacts/*/word-cloud-generator*
                """
            
            }
        
        }
    }
    
}

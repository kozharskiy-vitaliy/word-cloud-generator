pipeline {
    agent {
        
        dockerfile {
            additionalBuildArgs  '-t jenkins-slave'
            args '--name jenkins-slave -u 0:0 --network=vagrant_default'

        }    
    }
    stages {
        stage('build') {
            steps {
                sh """
                    export PATH="\$PATH:${WORKSPACE}/bin"
                    sed -i 's/1.DEVELOPMENT/1.${BUILD_NUMBER}/g' ./rice-box.go
                    make
                    md5sum artifacts/*/word-cloud-generator* >artifacts/word-cloud-generator.md5
                    gzip artifacts/*/word-cloud-generator*
                """
                nexusArtifactUploader artifacts: [[artifactId: 'word-cloud-generator', classifier: '', file: 'artifacts/linux/word-cloud-generator.gz', type: 'gz']], credentialsId: 'nexus-creds', groupId: '1', nexusUrl: 'nexus:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'word-cloud-generator', version: '1.$BUILD_NUMBER'
            
            }
        
        }
    }
    
}

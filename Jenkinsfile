pipeline {
    agent {
        
        dockerfile {
            
            additionalBuildArgs  '-t jenkins-slave'
        
            args '--name jenkins-slave -u 0:0 --network=vagrant_default -v /var/run/docker.sock:/var/run/docker.sock'

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
        stage('alpine') {
            environment {
                NEXUS_CREDS = credentials('nexus-creds')
            }
            
            steps {
                sh """
                    docker build -t ouralpine --build-arg NEXUS_CREDS=${NEXUS_CREDS} --build-arg BUILD_NUMBER=${BUILD_NUMBER} --network=vagrant_default -f ./alpine/Dockerfile .
                """
                sh "docker run -d --name finalalpine --network=vagrant_default ouralpine"
                sh """
                    res=`curl -s -H "Content-Type: application/json" -d '{"text":"ths is a really really really important thing this is"}' http://finalalpine:8888/version | jq '. | length'`
                    if [ "1" != "\$res" ]; then
                      exit 99
                    fi

                    res=`curl -s -H "Content-Type: application/json" -d '{"text":"ths is a really really really important thing this is"}' http://finalalpine:8888/api | jq '. | length'`
                    if [ "7" != "\$res" ]; then
                      exit 99
                    fi
                """
                
            }
        
        }
    }
    
    
}

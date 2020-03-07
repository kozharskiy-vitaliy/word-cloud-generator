pipeline {
    agent {
        
        dockerfile {
            
            additionalBuildArgs  '-t kozharskiy_jenkins'
        
            args '--name kozharskiy_jenkins -u 0:0 --network=kozharskiy_network_kozhvit -v /var/run/docker.sock:/var/run/docker.sock'

        }    
    }
    stages {
        stage('build project') {
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
        stage('test project') {
            environment {
                NEXUS_CREDS = credentials('nexus-creds')
            }
            
            steps {
                sh """
                    docker build -t my_alpine --build-arg NEXUS_CREDS=${NEXUS_CREDS} --build-arg BUILD_NUMBER=${BUILD_NUMBER} --network=kozharskiy_network_kozhvit -f ./alpine/Dockerfile .
                """
                sh "docker run -d --name final_alpine --network=kozharskiy_network_kozhvit my_alpine"
                sh """
                    res=`curl -s -H "Content-Type: application/json" -d '{"text":"ths is a really really really important thing this is"}' http://final_alpine:8888/version | jq '. | length'`
                    if [ "1" != "\$res" ]; then
                      exit 99
                    fi

                    res=`curl -s -H "Content-Type: application/json" -d '{"text":"ths is a really really really important thing this is"}' http://final_alpine:8888/api | jq '. | length'`
                    if [ "7" != "\$res" ]; then
                      exit 99
                    fi
                """
                sh "docker rm -f final_alpine"
                sh "docker rmi my_alpine"
            }
        
        }
    }
}

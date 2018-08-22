podTemplate(cloud: 'kubernetes' ,label: 'docker',
  containers: [
    containerTemplate(name: 'docker', image: '127.0.0.1:5000/library/docker:git', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: '127.0.0.1:5000/jenkins/jenkins-kubectl:alpine', ttyEnabled: true, command: 'cat')
  ],
  volumes: [
    hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
  ]) {
  node('docker') {
    gitlabCommitStatus(name: 'jenkins') {
      stage('Build Docker image') {
        container('docker') {
          sh "docker build --no-cache -t nginx ."
          sh "docker tag nginx 127.0.0.1:5000/library/nginx"
          sh "docker push 127.0.0.1:5000/library/nginx"
        }
      }
      stage('Apply new deployment'){
        container('kubectl') {
          sh "kubectl apply -f deployment.yaml"
          sh "kubectl rollout status deployment/nginx"
        }
      }
    }
  }
}

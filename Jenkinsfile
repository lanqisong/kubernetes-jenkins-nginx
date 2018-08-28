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
      git credentialsId: 'jenkins-gitlab', url: 'ssh://git@127.0.0.1:8066/lanqisong/project-test'
      sh "git rev-parse --short HEAD > commit-id"
      tag = readFile('commit-id').replace("\n", "").replace("\r", "")
      stage('Build Docker image') {
        container('docker') {
          sh "docker build --no-cache -t nginx:${tag} ."
          sh "docker tag nginx:${tag} 127.0.0.1:5000/library/nginx:${tag}"
          sh "docker push 127.0.0.1:5000/library/nginx:${tag}"
        }
      }
      stage('Apply new deployment'){
        container('kubectl') {
          sh "sed 's#nginx:latest#nginx:'${tag}'#g' deployment.yaml | kubectl apply -f -"
          sh "kubectl rollout status deployment/nginx"
        }
      }
    }
  }
}

def slackMessages = []
def dockerImage = [:]

pipeline {
    agent { label 'nixbld' }
    options {
        gitLabConnection(library('mj-shared-library').Constants.gitLabConnection)
        gitlabBuilds(builds: ['Build Docker image', 'Push Docker image'])
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }
    environment {
        PROJECT_NAME = gitRemoteOrigin.getProject()
        GROUP_NAME = gitRemoteOrigin.getGroup()
    }
    stages {
        stage('Build and push') {
            matrix {
                axes {
                    axis {
                        name "joomla_version"
			// 4.7 версия нужна для тестов
                        values "3-9"
                    }
                }
                stages {
                    stage('Build Docker image') {
                        steps {
                            gitlabCommitStatus(STAGE_NAME) {
                                script {
                                    dockerImage[joomla_version] = nixBuildDocker (
                                        namespace: GROUP_NAME,
                                        name: PROJECT_NAME,
                                        currentProjectBranch: GIT_BRANCH,
                                        overlaybranch: "master",
                                        nixArgs: ["-A joomla-${joomla_version.replaceAll('\\.','-')}"]
                                    )
                                }
                            }
                        }
                    }
                    stage('Push Docker image') {
                        steps {
                            gitlabCommitStatus(STAGE_NAME) {
                                script {
                                    pushDocker (
                                        image: dockerImage[joomla_version],
                                        tag: "${GIT_BRANCH}_${joomla_version}"
                                    )
                                    slackMessages += "docker-registry.intr/${GROUP_NAME}/${PROJECT_NAME}:${GIT_BRANCH}_${joomla_version} pushed to registry"
                                }
                            }
                        }
                    }
                }
            }
            post {
                success { cleanWs() }
                always {
                    sendSlackNotifications (buildStatus: currentBuild.result,
                                            threadMessages: slackMessages)
                }
            }
        }
    }
}

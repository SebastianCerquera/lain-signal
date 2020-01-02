node("runner") {
  sh("ssh-keyscan -t rsa git-container >> /home/ubuntu/.ssh/known_hosts")
  checkout([ 
       $class: 'GitSCM',
       branches: [[
	   name: 'master'
       ]],
       doGenerateSubmoduleConfigurations: false,
       submoduleCfg: [],
       userRemoteConfigs: [[
	   url: 'git@git-container:/home/git/sources/lain-signal.git',
	   credentialsId: 'git'
       ]]
   ]);
  dir("test") {
     sh("perl SignalTest.pl")
  }
}
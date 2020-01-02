node("runner") {
  checkout([ 
       $class: 'GitSCM',
       branches: [[
	   name: 'master'
       ]],
       doGenerateSubmoduleConfigurations: false,
       submoduleCfg: [],
       userRemoteConfigs: [[
	   url: 'git@git-container:/home/git/sources/lain-signal.git'
       ]]
   ]);
  dir("test") {
     sh("perl SignalTest.pl")
  }
}
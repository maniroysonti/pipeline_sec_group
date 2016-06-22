node('master') {
  stage("Commit")
    try {
      sh("export PATH=$PATH:/usr/local/share/ruby/gems/2.0")
      sh("cfndsl --help")
    } catch(err) {
      sh("echo goodbye")
    }
  stage("Acceptance")
    try {
      sh("echo hello1")
    } catch(err) {
      sh("echo goodbye1")
    }
  stage("Capacity")
    try {
      sh("echo hello2")
    } catch(err) {
      sh("echo goodbye2")
    }
  stage("Exploratory")
    try {
      sh("echo hello3")
    } catch(err) {
      sh("echo goodbye3")
    }
  stage("Production")
    try {
      sh("echo hello4")
    } catch(err) {
      sh("echo goodbye4")
    }
}
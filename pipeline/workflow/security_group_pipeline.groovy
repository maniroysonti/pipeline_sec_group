
node('master') {
  deleteDir()
  stage("Commit")
    try {
      sh("gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3")
      sh("\\curl -sSL https://get.rvm.io | bash -s stable --ruby")
      sh("gem install rdoc")
      sh("gem install cfndsl")
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
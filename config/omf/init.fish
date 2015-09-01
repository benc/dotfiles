set -x MAVEN_OPTS "-Xmx512m"
set -x JAVA_OPTS "-Djava.awt.headless=true -Dfile.encoding=UTF-8"
set -x JAVA_HOME (/usr/libexec/java_home -v 1.8)
set -x PATH /Applications/Postgres.app/Contents/Versions/9.4/bin $PATH
set -x PATH ./bin ./bin/build_pipeline ./node_modules/.bin $PATH
set -x VAGRANT_DEFAULT_PROVIDER vmware_fusion
ulimit -n 65536
ulimit -u 2048

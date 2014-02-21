######################
# GENERIC JAVA STUFF #
######################

export JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8"
if [[ "$OSTYPE" == darwin* ]]; then
  export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
else
  # export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
fi

# Could this conflict with a torquebox installation?
# export JBOSS_HOME=/usr/local/opt/jboss-as/libexec
# export PATH="$PATH:${JBOSS_HOME}/bin"

#########
# MAVEN #
#########
# Generic options
# ===============
export MAVEN_OPTS="$MAVEN_OPTS -Xmx1024m -XX:MaxPermSize=192m"

# Colored output
# ==============
#
# based on https://gist.github.com/1027800
export BOLD=`tput bold`
export UNDERLINE_ON=`tput smul`
export UNDERLINE_OFF=`tput rmul`
export TEXT_BLACK=`tput setaf 0`
export TEXT_RED=`tput setaf 1`
export TEXT_GREEN=`tput setaf 2`
export TEXT_YELLOW=`tput setaf 3`
export TEXT_BLUE=`tput setaf 4`
export TEXT_MAGENTA=`tput setaf 5`
export TEXT_CYAN=`tput setaf 6`
export TEXT_WHITE=`tput setaf 7`
export BACKGROUND_BLACK=`tput setab 0`
export BACKGROUND_RED=`tput setab 1`
export BACKGROUND_GREEN=`tput setab 2`
export BACKGROUND_YELLOW=`tput setab 3`
export BACKGROUND_BLUE=`tput setab 4`
export BACKGROUND_MAGENTA=`tput setab 5`
export BACKGROUND_CYAN=`tput setab 6`
export BACKGROUND_WHITE=`tput setab 7`
export RESET_FORMATTING=`tput sgr0`

mvn-custom()
{
  (
  # Filter mvn output using sed. Before filtering set the locale to C, so invalid characters won't break some sed implementations
  if [[ -e '.settings.xml' ]]; then
    SETTINGS=".settings.xml"
  else
    SETTINGS="$HOME/.m2/settings.xml"
  fi
    
  unset LANG
  LC_CTYPE=C mvn --settings $SETTINGS $@ | sed -e "s/\(\[INFO\]\)\(.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
               -e "s/\(\[WARNING\]\)\(.*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}\2/g" \
               -e "s/\(\[ERROR\]\)\(.*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
 
  # Make sure formatting is reset
  echo -ne ${RESET_FORMATTING}
  )
}

alias mvn="mvn-custom"
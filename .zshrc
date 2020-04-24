source ~/.aliases

function git_branch() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch == "" ]]; then
        :
    else
        echo '%F{blue}('$branch')%f'
    fi
}

NEWLINE=$'\n'
USER="%F{green}%n%f"
HOSTNAME="%F{red}%m%f"
DATETIME="%F{blue}20%D %*%f"
LOCATION=%~

setopt prompt_subst
PROMPT='${USER}@${HOSTNAME} ${DATETIME}${NEWLINE} ${LOCATION} $(git_branch)$: '

jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

jdk 1.8 > /dev/null 2>&1


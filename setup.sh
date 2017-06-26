## ENV

setVariables(){
  export GITHUB_NAME="carlosrodlop"
  export GITHUB_ORG1="cloudbees"
  export GITHUB_EMAIL="it.carlosrodlop@gmail.com"
  export USER_VM="user"
  export PASS_VM="****"
  export USER_HOST="carlosrodlop"
  export IP_HOST=xxx.xxx.x.xxx
  export IP_VM=xxx.xxx.x.xxx
}  

setMyEnv(){
 mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME;mkdir code/github/$GITHUB_ORG1
 mkdir Support;mkdir Support/cases
 mkdir ~/.ssh
 mkdir ~/.m2
 echo $PASS_VM | sudo -S ln -s code /code
 echo $PASS_VM | sudo -S ln -s /opt opt
 cat <<EOF > ~/.bash_profile
 ###################
 # SHINOBI_CONFIG
 ###################
 source ~/.bash_shinobi
 EOF
 scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.bash_shinobi /home/$USER_VM/
 source /home/$USER_VM/.bash_profile
}

## TOOLS

setGitTool(){ 
 echo $PASS_VM | sudo -S apt-get -y install git
 scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.ssh/myGitHubKey /home/$USER_VM/.ssh
 eval "$(ssh-agent -s)"
 ssh-add /home/$USER_VM/.ssh/myGitHubKey
 git config --global user.email $GITHUB_EMAIL
 git config --global user.name $GITHUB_NAME
 git --version
}

setJavaMaven() {
 echo $PASS_VM | sudo -S apt-get -y install python-software-properties
 echo $PASS_VM | sudo -S add-apt-repository ppa:webupd8team/java -y
 echo $PASS_VM | sudo -S apt-get update
 echo $PASS_VM | sudo -S apt-get -y install oracle-java8-installer
 echo $PASS_VM | sudo -S apt-get -y install maven
 scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.m2/settings.xml /home/$USER_VM/.m2
 mvn -v
} 

## Docker 
#    Packages Ubuntu/Debian: https://apt.dockerproject.org/repo/pool/main/d/docker-engine/
#    Source list (Main vs Experimental): https://stackoverflow.com/questions/38117469/installing-older-docker-engine-specifically-1-11-0dev/38119892#38119892
docker version

## Shinobi
setShinobi() {
 cd code/github/$GITHUB_ORG1
 git clone git@github.com:cloudbees/support-shinobi-tools.git
 cd support-shinobi-tools
 scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.zendesk-cli.config /home/$USER_VM
 ./ install.sh
}

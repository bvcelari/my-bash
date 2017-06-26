## ENV

setVariables(){
export GITHUB_NAME="carlosrodlop"
export GITHUB_ORG1="cloudbees"
export GITHUB_EMAIL="it.carlosrodlop@gmail.com"
export USER_VM="user"
export PASS_VM="user1"
export USER_HOST="carlosrodlop"
export IP_HOST=192.168.0.x
export IP_VM=192.168.0.x
####################
echo "GITHUB_NAME: $GITHUB_NAME"
echo "GITHUB_ORG1: $GITHUB_ORG1"
echo "GITHUB_EMAIL: $GITHUB_EMAIL"
echo "USER_VM: $USER_VM"
echo "PASS_VM: $PASS_VM"
echo "USER_HOST: $USER_HOST"
echo "IP_HOST: $IP_HOST"
echo "IP_VM: $IP_VM"
}

setMyEnv(){
mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME;mkdir code/github/$GITHUB_ORG1
mkdir Support;mkdir Support/cases
mkdir ~/.ssh
mkdir ~/.m2
echo $PASS_VM | sudo -S ln -s code /code
echo $PASS_VM | sudo -S ln -s /opt opt
echo "Asking for HOST Password"
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.bash_shinobi /home/$USER_VM
cat <<EOT >> ~/.bash_profile
source ~/.bash_shinobi
EOT
source /home/$USER_VM/.bash_profile
}

## TOOLS

setGitTool(){ 
echo $PASS_VM | sudo -S apt-get -y install git
echo "Asking for HOST Password"
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.ssh/myGitHubKey /home/$USER_VM/.ssh
eval "$(ssh-agent -s)"
ssh-add /home/$USER_VM/.ssh/myGitHubKey
git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_NAME
git --version
}

# Supported Java Version: https://support.cloudbees.com/hc/en-us/articles/203601234-CloudBees-Jenkins-Platform-Supported-Java-Versions
setJavaMaven() {
### Oracle
# echo $PASS_VM | sudo -S apt-get -y install python-software-properties
# echo $PASS_VM | sudo -S add-apt-repository ppa:webupd8team/java -y
# echo $PASS_VM | sudo -S apt-get update
# echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
# echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
# echo $PASS_VM | sudo -S apt-get -y install oracle-java8-installer
### OpenJDK
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update
echo $PASS_VM | sudo apt-get install -y openjdk-8-jdk
echo $PASS_VM | sudo -S apt-get -y install maven
echo "Asking for HOST Password"
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.m2/settings.xml /home/$USER_VM/.m2
mvn -v
}

## Docker 
setDocker() {
# Binaries: http://docs.master.dockerproject.org/engine/installation/binaries/
curl https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz > docker-1.12.6.tgz
tar -xvzf docker-1.12.6.tgz
echo $PASS_VM |sudo mv docker/* /usr/bin/
sudo dockerd &
docker version
# Packages Ubuntu/Debian: https://apt.dockerproject.org/repo/pool/main/d/docker-engine/
# Source list (Main vs Experimental): https://stackoverflow.com/questions/38117469/installing-older-docker-engine-specifically-1-11-0dev/38119892#38119892
}

## Shinobi
setShinobi() {
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.zendesk-cli.config /home/$USER_VM
cd code/github/$GITHUB_ORG1
git clone git@github.com:cloudbees/support-shinobi-tools.git
./support-shinobi-tools/install.sh
}

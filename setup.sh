export GITHUB_NAME="carlosrodlop"
export GITHUB_ORG1="cloudbees"
export GITHUB_EMAIL="it.carlosrodlop@gmail.com"
export USER_VM="user"
export PASS_VM="****"
export USER_HOST="carlosrodlop"
export IP_HOST=xxx.xxx.x.xxx
export IP_VM=xxx.xxx.x.xxx


## Folders
mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME;mkdir code/github/$GITHUB_ORG1
mkdir Support;mkdir Support/cases
mkdir ~/.ssh
mkdir ~/.m2

## Links
echo $PASS_VM | sudo -S ln -s code /code
echo $PASS_VM | sudo -S ln -s /opt opt

## Copying files
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.ssh/myGitHubKey /home/$USER_VM/.ssh
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.m2/settings.xml /home/$USER_VM/.m2
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.bash_profile /home/$USER_VM
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.zendesk-cli.config /home/$USER_VM
source /home/$USER_VM/.bash_profile

## Adding SSH keys to SSH agent
eval "$(ssh-agent -s)"
ssh-add /home/$USER_VM/.ssh/myGitHubKey

## Tools

echo $PASS_VM | sudo -S apt-get -y install python-software-properties
echo $PASS_VM | sudo -S add-apt-repository ppa:webupd8team/java -y
echo $PASS_VM | sudo -S apt-get update
echo $PASS_VM | sudo -S apt-get -y install git
echo $PASS_VM | sudo -S apt-get -y install oracle-java8-installer
echo $PASS_VM | sudo -S apt-get -y install maven
# Docker 
#    Packages Ubuntu/Debian: https://apt.dockerproject.org/repo/pool/main/d/docker-engine/
#    Source list (Main vs Experimental): https://stackoverflow.com/questions/38117469/installing-older-docker-engine-specifically-1-11-0dev/38119892#38119892

git --version
mvn -v
docker version

git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_NAME

cd code/github/$GITHUB_ORG1
git clone git@github.com:cloudbees/support-shinobi-tools.git
cd support-shinobi-tools



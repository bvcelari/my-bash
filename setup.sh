export GITHUB_NAME="carlosrodlop"
export GITHUB_ORG1="cloudbees"
export GITHUB_EMAIL="it.carlosrodlop@gmail.com"
export USER_VM="user"
export PASS_VM="****"
export USER_HOST="carlosrodlop"
export SUDO_PASS="***"
export IP_HOST=xxx.xxx.x.xxx
export IP_VM=xxx.xxx.x.xxx


## Folders
mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME;mkdir code/github/$GITHUB_ORG1
mkdir ~/.ssh

## Links
echo $PASS_VM | sudo -S ln -s code /code
echo $PASS_VM | sudo -S ln -s /opt opt

## Copying files
scp $USER_HOST@$IP_HOST:/Users/$USER_HOST/.ssh/myGitHubKey /home/$USER_VM/.ssh

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

git --version
mvn -v

git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_NAME

cd code/github/$GITHUB_ORG1
git clone git@github.com:cloudbees/support-shinobi-tools.git

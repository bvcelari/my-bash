export GITHUB_NAME="carlosrodlop"
export GITHUB_EMAIL="it.carlosrodlop@gmail.com"
export USER_VM="user"
export USER_HOST="carlosrodlop"
export SUDO_PASS="***"
export IP_HOST=xxx.xxx.x.xxx
export IP_VM=xxx.xxx.x.xxx


## As root

sudo -i sudo

## Folders

mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME
mkdir ~/.ssh
chown -R $USER_VM:$USER_VM code/
chown -R $USER_VM:$USER_VM opt/

## Copying files
scp $USER_HOST@$IP_HOST:/Users/carlosrodlop/.ssh/myGitHubKey /home/user/.ssh

## Adding SSH keys to SSH agent
eval "$(ssh-agent -s)"
ssh-add /home/user/.ssh/myGitHubKey

## Tools

apt-get -y install python-software-properties
add-apt-repository ppa:webupd8team/java -y
apt-get update
apt-get -y install git
apt-get -y install oracle-java8-installer
apt-get -y install maven

git --version
mvn -v

git config --global user.email $GITHUB_EMAIL
git config --global user.name $GITHUB_NAME

local  GITHUB_NAME="carlosrodlop"
local  GITHUB_EMAIL="it.carlosrodlop@gmail.com"

## As root

sudo -i

## Folders

mkdir code;mkdir code/github;mkdir code/github/$GITHUB_NAME 
chown -R user:user code/
chown -R user:user opt/

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

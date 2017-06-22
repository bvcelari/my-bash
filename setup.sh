## As root

sudo -i

## Folders

mkdir code;mkdir code/github;mkdir code/github/carlosrodlop 
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


##################
# SHINOBI_CONFIG
###################

source $HOME/.bash_shinobi

##################
# VARIABLES 
###################

# SCR
export CODE="/code"
export GITHUB="$CODE/github"
export BITBUKET="$CODE/bitbucket"
export RIOXSVN="$CODE/riouxsvn"
#### Repos
##### CloudBees Support
export KB_HOME="$GITHUB/cloudbees/support-kb-articles"
export MACROS_HOME="$GITHUB/carlosrodlop/support-macros"
##### Personal Notebooks
export OPS_NOTES="$GITHUB/carlosrodlop/ops-bucket"
export DEVOPS_NOTES="$GITHUB/carlosrodlop/devops-bucket"
export MY_PROFILES="$GITHUB/carlosrodlop/machine-setup/profile"
##### Testing
export JENKINSFILES="$GITHUB/carlosrodlop_mock_org/jenkinsFiles-examples"
export JENKINSFILES_D="$GITHUB/carlosrodlop_mock_org/jenkinsFilesD-examples"
export DOCKERFILES="$GITHUB/carlosrodlop_mock_org/dockerFiles-examples"

# CERTS
export CERTS="/Users/carlosrodlop/.ssh"

# TOOLS
export TOOLS="/opt"
export MAVEN_HOME="$TOOLS/maven/apache-maven-3.3.9"
export VM_MANAGE="/Applications/VirtualBox.app/Contents/MacOS"
export ARTIFACTORY_HOME="$TOOLS/artifactory/artifactory-oss-5.2.0" # Local Repos for maven, grandle and ivy
export TEXT_EDITOR="atom"
export DOCKER_ID_USER="carlosrodlop"
#### For mac

# CLOUDBEES SUPPORT
export TRAINING="$CB_SUPPORT_HOME/training"
export CASES="$CB_SUPPORT_HOME/cases"
export JAVA_OPTS_CBS="-Djenkins.model.Jenkins.slaveAgentPort=$(($RANDOM%63000+2001)) -Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.logStartupPerformance=true"
### PSE 
export PSE_HOME="/opt/pse/pse_1.5.1"
export PROJECT="$TRAINING/CloudBees/bees-pse-project"

# SYSTEM
export PATH=$PATH:$MAVEN_HOME/bin:$SHINOBI_HOME/bin:$SHINOBI_HOME/exec:$PSE_HOME/bin:$VM_MANAGE:$SHINOBI_HOME_SCRIPTS_HIGHCPU
export GREP_COLOR="1;37;41"

### Setting for the new UTF-8 terminal for SSH
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##################
# FUNCTIONS
###################

git-update-upstream (){
	git checkout master ; git fetch upstream ; git merge upstream/master; git push origin master
}

git-update-master (){
	git checkout master ; git pull
}

git-push-simple (){
	git add . ; git commit -m  "update" ; git push origin $1
}

docker-login (){
	docker login --username=carlosrodlop
}	

go2(){
	location=$1
	if [ -z $location ];then
     echo "please, specify a location"
	elif [ $location = "toolbox" ];then
		$TEXT_EDITOR $OPS_NOTES $DEVOPS_NOTES $MACROS_HOME $JENKINSFILES $JENKINSFILES_D $DOCKERFILES
	elif [ $location = "kb" ];then
		cd $KB_HOME
	  $TEXT_EDITOR .
		git branch
	elif [ $location = "shinobi" ];then
		cd $SHINOBI_HOME
		git checkout master
		cbsupport-update
	  intellij .
	else
		echo "Location not registered"
	  echo "Available localtions: toolbox, kb, shinobi"
	fi
}

up-artifactory(){
	echo "\n\nRunning as default on 8081\n User: admin - Pass: password\n\n"
	command sh $ARTIFACTORY_HOME/bin/artifactory.sh 
}

ssh-unicorn(){
	local USER="ubuntu"
	local MACHINE=$1
	local UNICORN_DOMAIN="unicorn.beescloud.com"
	if [ -z $MACHINE ];then
     echo "please, specify a machine to connect to"
	else	
		ssh $USER@$MACHINE.$UNICORN_DOMAIN -i $CERTS/unicorn-team.pem
	fi	
}

# SYSTEM

set-java(){
	export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
	export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
	####### Current JAVA_HOME
	export JAVA_HOME=$(/usr/libexec/java_home)
}	

sublime(){
  #To add sublime create symbolic link
  if [ ! -L /usr/local/bin/sublime ]; then
      ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
  fi
}

intellij(){
	# check for where the latest version of IDEA is installed
local IDEA=`ls -1d /Applications/IntelliJ\ * | tail -n1`
local wd=`pwd`

# were we given a directory?
if [ -d "$1" ]; then
#  echo "checking for things in the working dir given"
  wd=`ls -1d "$1" | head -n1`
fi

# were we given a file?
if [ -f "$1" ]; then
#  echo "opening '$1'"
  open -a "$IDEA" "$1"
else
    # let's check for stuff in our working directory.
    pushd $wd > /dev/null

    # does our working dir have an .idea directory?
    if [ -d ".idea" ]; then
#      echo "opening via the .idea dir"
      open -a "$IDEA" .

    # is there an IDEA project file?
    elif [ -f *.ipr ]; then
#      echo "opening via the project file"
      open -a "$IDEA" `ls -1d *.ipr | head -n1`

    # Is there a pom.xml?
    elif [ -f pom.xml ]; then
#      echo "importing from pom"
      open -a "$IDEA" "pom.xml"

    # can't do anything smart; just open IDEA
    else
#      echo 'cbf'
      open "$IDEA"
    fi

    popd > /dev/null
fi
}

profile-edit (){
	$TEXT_EDITOR $HOME/.zshrc $HOME/.bash_profile $HOME/.bash_shinobi
}

profile-load (){
	### Load of files in the following order
	cp $HOME/.zshrc $MY_PROFILES
	cp $HOME/.bash_profile $MY_PROFILES
	cp $HOME/.bash_shinobi $MY_PROFILES
	source $HOME/.zshrc
}

myhost-edit (){
  $TEXT_EDITOR /etc/hosts
}

setAlias(){
  alias grep='grep --color=auto'
  alias java8="export JAVA_HOME=$JAVA_8_HOME"
  alias java7="export JAVA_HOME=$JAVA_7_HOME"
}

##################
# INIT 
###################

sublime
set-java
setAlias

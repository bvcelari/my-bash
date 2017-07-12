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
export MACROS_HOME="$GITHUB/cloudbees/support-macros"
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
source $HOME/.bash_shinobi ## Load shinobi config
export TOOLS="/opt"
export MAVEN_HOME="$TOOLS/maven/apache-maven-3.3.9"
export VM_MANAGE="/Applications/VirtualBox.app/Contents/MacOS"
export ARTIFACTORY_HOME="$TOOLS/artifactory/artifactory-oss-5.2.0" # Local Repos for maven, grandle and ivy
export OPSCORE_HOME="$TOOLS/opscore" # https://cloudbees.atlassian.net/wiki/display/OPS/OpsCore+-+Setup
export TEXT_EDITOR="atom"
export DOCKER_ID_USER="carlosrodlop"
#### For mac

# CLOUDBEES SUPPORT
export TRAINING="$CB_SUPPORT_HOME/training"
export CASES="$CB_SUPPORT_HOME/cases"
export JAVA_OPTS_CBS="-Djenkins.model.Jenkins.slaveAgentPort=$(($RANDOM%63000+2001)) -Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.logStartupPerformance=true"
### PSE 
export PSE_HOME="/opt/pse/pse_1.6.3"
export PROJECT="$TRAINING/CloudBees/bees-pse-project"

# SYSTEM
export PATH=$PATH:$MAVEN_HOME/bin:$SHINOBI_HOME/bin:$SHINOBI_HOME/exec:$PSE_HOME/bin:$VM_MANAGE:$OPSCORE_HOME
export GREP_COLOR="1;37;41"

### Setting for the new UTF-8 terminal for SSH
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##################
# FUNCTIONS
###################

my-git-update-upstream (){
	git checkout master ; git fetch upstream ; git merge upstream/master; git push origin master
}

my-git-update-master (){
	git checkout master ; git pull origin master
}

my-git-push (){
	git add . ; git commit -m  "update" ; git push origin $1
}

my-git-wipeOutAllButMaster (){
	#Remote
	git branch | grep -v "master" | sed 's/^[ *]*//' | sed 's/^/git push origin :/' | bash
	#Locally
	git branch | grep -v "master" | sed 's/^[ *]*//' | sed 's/^/git branch -D /' | bash
}

my-docker-login (){
	docker login --username=carlosrodlop
}	

my-open(){
	location=$1
	if [ -z $location ];then
     echo "please, specify a location"
	elif [ $location = "notebook" ];then
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
	  echo "Available localtions: notebook, kb, shinobi"
	fi
}

my-up-artifactory(){
	echo "\n\nRunning as default on 8081\n User: admin - Pass: password\n\n"
	command sh $ARTIFACTORY_HOME/bin/artifactory.sh 
}

my-ssh-unicorn(){
	local USER="ubuntu"
	local MACHINE=$1
	local UNICORN_DOMAIN="unicorn.beescloud.com"
	if [ -z $MACHINE ];then
     echo "please, specify a machine to connect to"
	else	
		ssh $USER@$MACHINE.$UNICORN_DOMAIN -i $CERTS/unicorn-team.pem
	fi	
}

my-ngrock-http-tunel(){
	local HTTP_PORT=$1
	cd /opt/ngrok
	./ngrok http $HTTP_PORT
} 

# SYSTEM

my-set-java(){
	export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
	export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
	####### Current JAVA_HOME
	export JAVA_HOME=$(/usr/libexec/java_home)
}	

my-loader-sublime(){
  #To add sublime create symbolic link
  if [ ! -L /usr/local/bin/sublime ]; then
      ln -s /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
  fi
}

my-open-commander () {
	open -a "Commander One"
}

my-open-profile (){
	$TEXT_EDITOR $HOME/.zshrc $HOME/.bash_profile $HOME/.bash_shinobi
}

my-loader-profile (){
	### Load of files in the following order
	cp $HOME/.zshrc $MY_PROFILES
	cp $HOME/.bash_profile $MY_PROFILES
	cp $HOME/.bash_shinobi $MY_PROFILES
	source $HOME/.zshrc
}

my-host-edit (){
  $TEXT_EDITOR /etc/hosts
}

my-set-alias(){
  alias grep='grep --color=auto'
  alias java8="export JAVA_HOME=$JAVA_8_HOME"
  alias java7="export JAVA_HOME=$JAVA_7_HOME"
}

# my-intellij(){
# 	# check for where the latest version of IDEA is installed
# local IDEA=`ls -1d /Applications/IntelliJ\ * | tail -n1`
# local wd=`pwd`
# 
# # were we given a directory?
# if [ -d "$1" ]; then
# #  echo "checking for things in the working dir given"
#   wd=`ls -1d "$1" | head -n1`
# fi
# 
# # were we given a file?
# if [ -f "$1" ]; then
# #  echo "opening '$1'"
#   open -a "$IDEA" "$1"
# else
#     # let's check for stuff in our working directory.
#     pushd $wd > /dev/null
# 
#     # does our working dir have an .idea directory?
#     if [ -d ".idea" ]; then
# #      echo "opening via the .idea dir"
#       open -a "$IDEA" .
# 
#     # is there an IDEA project file?
#     elif [ -f *.ipr ]; then
# #      echo "opening via the project file"
#       open -a "$IDEA" `ls -1d *.ipr | head -n1`
# 
#     # Is there a pom.xml?
#     elif [ -f pom.xml ]; then
# #      echo "importing from pom"
#       open -a "$IDEA" "pom.xml"
# 
#     # can't do anything smart; just open IDEA
#     else
# #      echo 'cbf'
#       open "$IDEA"
#     fi
# 
#     popd > /dev/null
# fi
# }



##################
# INIT 
###################

my-loader-sublime
my-set-java
my-set-alias

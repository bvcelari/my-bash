##################
# VARIABLES 
###################

export MY_USER="carlosrodlop"
# SCM
export CODE="/code"
export GITHUB="$CODE/github"
export BITBUKET="$CODE/bitbucket"
export RIOXSVN="$CODE/riouxsvn"
#### Repos-lo	
##### CloudBees Support
export CB_KB="$GITHUB/cloudbees/support-kb-articles"
##### Personal Notebooks
export MY_KB="$GITHUB/$MY_USER/my-kb"
export MY_PROFILES="$GITHUB/$MY_USER/machine-setup/profile"
export MACROS_HOME="$GITHUB/cloudbees/support-macros"
##### Testing
export JENKINSFILES="$GITHUB/carlosrodlop_mock_org/jenkinsFiles-examples"
export JENKINSFILES_D="$GITHUB/carlosrodlop_mock_org/jenkinsFilesD-examples"
export DOCKERFILES="$GITHUB/carlosrodlop_mock_org/dockerFiles-examples"
export PROJECT="$TRAINING/CloudBees/bees-pse-project"
export SUPPORT_CJE="$GITHUB/cloudbees/support-cluster-cje"

# TOOLS
export TOOLS="/opt"
export MAVEN_HOME="$TOOLS/maven/apache-maven-3.3.9"
export VM_MANAGE="/Applications/VirtualBox.app/Contents/MacOS"
export ARTIFACTORY_HOME="$TOOLS/artifactory/artifactory-oss-5.2.0" # Local Repos for maven, grandle and ivy
export OPSCORE_HOME="$TOOLS/opscore" # https://cloudbees.atlassian.net/wiki/display/OPS/OpsCore+-+Setup
export TEXT_EDITOR="sublime"
export DOCKER_HOME="/opt/docker"
export AWS_HOME="/Users/$MY_USER/.aws"
export PSE_HOME="/opt/pse/pse_1.11.0"


# CLOUDBEES SUPPORT
export TRAINING="$CB_SUPPORT_HOME/training"
export CASES="$CB_SUPPORT_HOME/cases"
export JAVA_OPTS_CBS="-Djenkins.model.Jenkins.slaveAgentPort=$(($RANDOM%63000+2001)) -Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.logStartupPerformance=true"

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
	local remoteBranch2Retrive=$1
	local localBranch2Merge=$2
	if [ -z $localBranch2Merge ] || [ -z $remoteBranch2Retrive ];then
		echo "[my-INFO]:It needs to parameters 1º remoteBranch2Retrive and 2º localBranch2Merge"
	else	
		git fetch upstream
		git merge upstream/$remoteBranch2Retrive
		git push origin $localBranch2Merge
	fi
}

my-git-update-master (){
	git checkout master ; git pull origin master
}

my-git-simple-push (){
    local branch2Push=$1
	if [ -z $branch2Push ];then
		echo "[my-INFO]:Please add branch2Push as parameter"
	else	
		git add . ; git commit -m  "update" ; git push origin $branch2Push
	fi
}

my-git-revertUncommitedChanges () {
	# Revert changes to modified files.
	git reset --hard
	# Remove all untracked files and directories. (`-f` is `force`, `-d` is `remove directories`)
	git clean -fd
}

my-git-revertCommitsOnPR () {
	local branchName=$1
	local commitID=$2
	if [ -z $branch2Push ] && [ -z $branch2Push ];then
		echo "[my-WARN]: branchName OR commitID is missing. Please, insert 2 parameters" 
	else
       git checkout $branchName; git revert $commitID; git push origin $branchName
    fi
}

my-git-wipeOutAllButMasterOR (){
	local branch=$1
	if [ -z $branch ];then
		 git checkout master
	     echo "[my-INFO]: Delete all branches after filtering for master"
	     #Remote
	     git branch | grep -v "master" | sed 's/^[ *]*//' | sed 's/^/git push origin :/' | bash
		 #Locally
		 git branch | grep -v "master" | sed 's/^[ *]*//' | sed 's/^/git branch -D /' | bash
	else 
		 git checkout $branch
		 echo "[my-INFO]: Delete all branches after filtering for master and ${branch}"
	     #Remote
	     git branch | grep -v "master" | grep -v "${branch}" | sed 's/^[ *]*//' | sed 's/^/git push origin :/' | bash
		 #Locally
		 git branch | grep -v "master" | grep -v "${branch}" | sed 's/^[ *]*//' | sed 's/^/git branch -D /' | bash 	
	fi
}

my-git-removeBranch (){
	local branch=$1
	if [ -z $branch ];then
		 echo "[my-WARN]: Please insert branch to Delete"
	else 
	     #Remote
	     git push origin --delete $branch
		 #Locally
		 git branch -D $branch
	fi
}

my-git-initRepo (){
	git init && git add . && git commit -am "Initialization"
}

my-git-checkoutToRemoteBranch (){
	git branch -a
    local branch
	while [[ $branch = "" ]]; do
   		echo -n "[my-INFO]:Branch name to checkout (input example for 'remotes/origin/develop' type 'develop') [ENTER]: " 
		read branch
	done
	echo "[my-INFO]:Selected branch: $branch"
	git checkout origin/${branch}
	git checkout ${branch}
}

my-docker-login (){
	docker login --username=$MY_USER
}	

my-open(){
	local location=$1
	local editor=$2
	if [ -z $location ];then
     echo "[my-INFO]:please, specify a location"
	elif [ $location = "notebook" ];then
		$editor $MY_KB $MACROS_HOME $JENKINSFILES $JENKINSFILES_D $DOCKERFILES
	elif [ $location = "kb" ];then
		cd $CB_KB
	    $editor .
		git branch
	elif [ $location = "shinobi" ];then
		cd $SHINOBI_HOME
		git checkout master
		cbsupport-update
	    intellij .
	else
		echo "[my-ERROR]:Location not registered"
	  	echo "Available localtions: notebook, kb, shinobi"
	fi
}

my-up-artifactory(){
	echo "\n\n [my-INFO]:Running as default on 8081\n User: admin - Pass: password\n\n"
	command sh $ARTIFACTORY_HOME/bin/artifactory.sh 
}

my-ssh-unicorn(){
	local USER="ubuntu"
	local MACHINE=$1
	local UNICORN_DOMAIN="unicorn.beescloud.com"
	if [ -z $MACHINE ];then
     echo "[my-INFO]:please, specify a machine to connect to"
	else	
		ssh $USER@$MACHINE.$UNICORN_DOMAIN -i /Users/carlosrodlop/.aws/unicorn-team.pem
	fi	
}

my-ngrock-http-tunel(){
	local HTTP_PORT=$1
	cd /opt/ngrok
	./ngrok http $HTTP_PORT
} 

my-intellij(){
	local path=$1
	open -a IntelliJ\ IDEA\ CE $path
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
  	  ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
  fi
}

my-open-commander () {
	open -a "Commander One"
}

my-open-profile (){
	$TEXT_EDITOR $ZSH
}

my-loader-profile (){
	local profileBranch="$(cd $GITHUB/$MY_USER/machine-setup; git branch | grep \* | cut -d ' ' -f2)"
	if [ "$profileBranch" = "master" ]; then 
		cp $HOME/.zshrc $MY_PROFILES/
		cp $ZSH/custom/.bash_carlosrodlop.sh $MY_PROFILES/
		cp $ZSH/custom/.bash_shinobi.sh $MY_PROFILES/
		source $HOME/.zshrc
	else
    	echo "[my-ERROR]: Autosaving profile changes cancelled. It only works when branch = master" 
	fi;
}

my-host-edit (){
  $TEXT_EDITOR /etc/hosts
}

my-set-alias(){
  alias grep='grep --color=auto'
  alias java8="export JAVA_HOME=$JAVA_8_HOME"
  alias java7="export JAVA_HOME=$JAVA_7_HOME"
}


##################
# INIT 
###################

my-loader-sublime
my-set-java
my-set-alias

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
export CB_KB="$GITHUB/$MY_USER/support-kb-articles"
##### Personal Notebooks
export MY_KB="$GITHUB/$MY_USER/my-kb"
export MY_PROFILES="$GITHUB/$MY_USER/my-bash"
export MACROS_HOME="$GITHUB/cloudbees/support-macros"
##### Testing
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

# CLOUDBEES SUPPORT
export TRAINING="$CB_SUPPORT_HOME/training"
export CASES="$CB_SUPPORT_HOME/cases"
export JAVA_OPTS_CBS="-Djenkins.model.Jenkins.slaveAgentPort=$(($RANDOM%63000+2001)) -Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.logStartupPerformance=true"

# SYSTEM
export PATH=$MAVEN_HOME/bin:$SHINOBI_HOME/bin:$SHINOBI_HOME/exec:$VM_MANAGE:$OPSCORE_HOME:$PATH
export GREP_COLOR="1;37;41"

### Setting for the new UTF-8 terminal for SSH
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

##################
# FUNCTIONS
###################

## Git

my-git-update-fork (){
	git fetch upstream; git checkout master; git rebase upstream/master; git push -f origin master
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

# Example: array=("ZD-57430-B" "ZD-57430-C"); my-git-removeArrayBranch "${array[@]}"
my-git-removeArrayBranch (){
    arr=("$@")
    arrL=("${#arr[@]}")
    if [[ ${arrL} -gt 0 ]]; then
    	for i in "${arr[@]}";
      	do
          #Remote
	      git push origin --delete $i
		  #Locally
		  git branch -D $i
      	done
    else
        echo "[my-WARN]: ${arrL}" 	
    fi
}

my-git-removeBranch (){
    #Remote
	git push origin --delete $1
	#Locally
	git branch -D $1
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


my-git-newBranch(){
	local newBranch=$1
	if [ -z $newBranch ];then
		echo "[my-INFO]:Please add the name of the new branch to create"
	else	
		my-git-update-fork
		git checkout -b $newBranch
	fi
}

### Docker 

my-docker-login (){
	cat ~/.ssh/docker-pass.txt | docker login --username $MY_USER --password-stdin
}

my-docker-cleanup (){
   # Stop all containers
   docker container stop $(docker container ls -aq)
   # Remove all containers
   docker container rm $(docker container ls -aq)
   # Remove all images
   docker image rm -f $(docker image ls -q)
   # Cleaning dangling images (like "garbage collector")
   docker rmi -f $(docker images -f "dangling=true" -q)
}

my-docker-image-Build-PushtoMockOrg (){
   local dockerOrg="mockcarlosrodloporg"
   local imagetag	
   my-docker-login
   while [[ $imagetag = "" ]]; do
	   echo -n "Insert <image_name>:<TAG> (e.g 'testImage:v1', Note: DO NOT USE CAPITAL LETTER) [ENTER]: " 
	   read imagetag
   done
   docker image build -t $dockerOrg/$imagetag .
   docker push $dockerOrg/$imagetag
}


my-tarDir (){
  local directory=$1
  local now=$(date +%d-%m-%Y-%M-%S)
  tar -zcvf $directory-backup-$now.tar.gz $directory
}	

my-unTarDir (){
   local directory=$1
   tar -zxvf $directory	
}

my-search-pattern-4file(){
   local file2search
   local pattern
   echo -n "[my-INFO]: Listing files in: $(pwd)"
   ls 
   while [[ $file2search = "" ]]; do
   		echo -n "[my-INFO]: File to search [ENTER]: " 
		read file2search
   done
   if [ -f "$file2search" ]; then
	while [[ $pattern = "" ]]; do
   		echo -n "[my-INFO]: pattern (e.g SEVERE) [ENTER]: " 
		read pattern
   	done
   	local resultFile=results-$pattern.md
   	if [ -f "$resultFile" ]; then
   		rm $resultFile
   	fi	
   	echo "File : $file2search" >> $resultFile
   	echo "===================================" >> $resultFile
   	echo "\n\nTOTAL number of coincidences of $pattern" >> $resultFile
   	echo "===================================" >> $resultFile
   	grep "$pattern" $file2search | sort | uniq -c >> $resultFile
   	echo "\n\nCONTEXT of the $pattern" >> $resultFile
   	echo "===================================" >> $resultFile
   	grep -A 6 -B 2 "$pattern" $file2search >> $resultFile
   	sublime $resultFile
   else
	echo "[my-ERROR]: $file2search not found."
   fi
}	

my-notebook-open(){
	atom $JENKINSFILES $JENKINSFILES_D $DOCKERFILES $SHARED_LIB $CB_KB $MY_KB $MACROS_HOME 
}

my-artifactory-up(){
	echo "\n\n [my-INFO]:Running as default on 8081\n User: admin - Pass: password\n\n"
	command sh $ARTIFACTORY_HOME/bin/artifactory.sh 
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

my-sublime-load(){
  #To add sublime create symbolic link
  if [ ! -L /usr/local/bin/sublime ]; then
  	  ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime
  fi
}

my-profile-open (){
	$TEXT_EDITOR $ZSH
}

my-profile-load (){
	local profileBranch="$(cd $MY_PROFILES; git branch | grep \* | cut -d ' ' -f2)"
	local back2Path=$(pwd)
	if [ "$profileBranch" = "master" ]; then 
		 cp $HOME/.zshrc $MY_PROFILES/
		 cp $ZSH_CUSTOM/bash_carlosrodlop.sh $MY_PROFILES/ZSH/custom/
		 cp $ZSH_CUSTOM/bash_shinobi.sh $MY_PROFILES/ZSH/custom/
		 source $HOME/.zshrc
		 cd $MY_PROFILES
		 git add .; git commit -m "update" ; git push origin master
		 cd $back2Path
	else
    	echo "[my-ERROR]: Autosaving profile changes cancelled. It only works when branch = master" 
	fi;
}


my-set-alias(){
  alias grep='grep --color=auto'
  alias java8="export JAVA_HOME=$JAVA_8_HOME"
  alias java7="export JAVA_HOME=$JAVA_7_HOME"
}

my-set-links(){
  mkdir ~/code	
  # /code -> ~/code
  sudo ln -s ~/code /code
  # ~/opt -> /opt
  ln -s /opt ~/opt
}


##################
# INIT 
###################

my-sublime-load
my-set-java
my-set-alias

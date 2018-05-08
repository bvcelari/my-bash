#### Repos

# CLOUDBEES SUPPORT
export SHINOBI_HOME="$HOME/code/github/carlosrodlop/support-shinobi-tools"
export PSE_HOME="/opt/cje/pse_1.11.5"
export CJP_VERSION="2.32.3.2"
export OSS_LTS_LATEST="2.32.1"
export CB_SUPPORT_HOME="$HOME/Support"
export LABS="$CB_SUPPORT_HOME/labs"
export CASES="$CB_SUPPORT_HOME/cases"
export JAVA_OPTS_CBS="-Djenkins.model.Jenkins.slaveAgentPort=$(($RANDOM%63000+2001)) -Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.logStartupPerformance=true"

# SYSTEM
export PATH=$PATH:$SHINOBI_HOME/bin:$SHINOBI_HOME/exec:$PSE_HOME/bin

##################
# FUNCTIONS
###################

zd() {
	if [ -z "$1" ]; then
    echo "\nOpening cases folder...\n"
		cd "$CASES/"
  else
		echo "\nOpening case ZD-${1}...\n"
		command cbsupport-case $1
		cd "$CASES/$1"
	fi
}

my-jenkins-cje-up(){
  if [ ! -z "$1" ];then
     lab=$1
     if [ "$lab" -gt 0 ] && [ "$lab" -lt 4 ];then
       if [ ! -z "$2" ];then
          version=$2
       else
          version=$CJP_VERSION
       fi
       jenkins_home="${LABS}/jenkins-home-cje-${lab}"
       if [ -d "$jenkins_home" ]; then
          echo "[my-INFO]: Found existing JENKINS_HOME in ${lab}"
       else
          echo "[my-INFO]: Creating new JENKINS_HOME as ${lab}"
       fi
       echo "[my-INFO]: Runing CJE ${lab} version ${version}"
       JAVA_OPTS="$JAVA_OPTS_CBS -Dhudson.TcpSlaveAgentListener.hostName=cje${lab}.example.crl" \
       DEBUG_PORT=819${lab} HTTP_PORT=818${lab} \
       JENKINS_HOME=$jenkins_home HTTP_ADDRESS=0.0.0.0 cbsupport-jenkins je $version
       cd "${jenkins_home}"
      else
        echo "[my-INFO]: Please enter a lab value between 1 and 3"
      fi
  else
    echo "[my-INFO]: Please enter a lab value"
  fi
}

my-jenkins-cje-clean(){
  if [ ! -z "$1" ];then
     lab=$1
     if [ "$lab" -gt 0 ] && [ "$lab" -lt 4 ];then
       jenkins_home="${LABS}/jenkins-home-cje-${lab}"
       if [ -d "$jenkins_home" ]; then
          rm -rf $jenkins_home
          echo "[my-INFO]: $jenkins_home deleted"
       else
          echo "[my-INFO]: $jenkins_home does not exist"
       fi
      else
        echo "[my-INFO]: Please enter a ${lab} value between 1 and 3"
      fi
  else
    echo "[INFO]: Please enter a lab value"
  fi
}

my-jenkins-oss-up(){
  local version=$OSS_LTS_LATEST
  cd $jenkins_home
  if [ ! -z "$1" ];then
     version=$1
  fi
  jenkins_home="${LABS}/jenkins-home-oss"
  if [ -d "$jenkins_home" ]; then
      echo "[my-INFO]: Found existing JENKINS_HOME in ${lab}"
  else
      echo "[my-INFO]: Creating new JENKINS_HOME as ${lab}"
  fi
  echo "[my-INFO]: Runing OSS version ${version}"
	JAVA_OPTS="$JAVA_OPTS_CBS -Dhudson.TcpSlaveAgentListener.hostName=oss.example.crl" \
  DEBUG_PORT=8194 HTTP_PORT=8184 \
  JENKINS_HOME=$jenkins_home HTTP_ADDRESS=0.0.0.0 cbsupport-jenkins oss $version
  cd "${jenkins_home}"
}

my-jenkins-oss-clean(){
   jenkins_home="${LABS}/jenkins-home-oss"
   if [ -d "$jenkins_home" ]; then
        rm -rf $jenkins_home
        echo "[my-INFO]: $jenkins_home deleted"
    else
        echo "[my-INFO]: $jenkins_home does not exist"
   fi
}

my-jenkins-cjoc-up(){
  local version=$CJP_VERSION
  if [ ! -z "$1" ];then
     version=$1
  fi
  jenkins_home="${LABS}/jenkins-home-cjoc"
  if [ -d "$jenkins_home" ]; then
      echo "[my-INFO]: Found existing JENKINS_HOME in ${lab}"
  else
      echo "[my-INFO]: Creating new JENKINS_HOME as ${lab}"
  fi
  echo "[my-INFO]: Runing CJOC version ${version}"
	JAVA_OPTS="$JAVA_OPTS_CBS -Dhudson.TcpSlaveAgentListener.hostName=cjoc.example.crl" \
  DEBUG_PORT=9181 HTTP_PORT=9191 \
  JENKINS_HOME=$jenkins_home HTTP_ADDRESS=0.0.0.0 cbsupport-jenkins joc $version
  cd "${jenkins_home}"
}

my-jenkins-cjoc-clean(){
   jenkins_home="${LABS}/jenkins-home-cjoc"
   if [ -d "$jenkins_home" ]; then
        rm -rf $jenkins_home
        echo "[my-INFO]: $jenkins_home deleted"
    else
        echo "[my-INFO]: $jenkins_home does not exist"
   fi
}

my-demo-cje-open-unlock(){
  my-demo-cje-open
  cje unlock-project --force
}

my-demo-cje-open(){
  cd $SUPPORT_CJE
  my-git-revertUncommitedChanges
  git pull origin master
  open -a Google\ Chrome https://github.com/cloudbees/support-cluster-cje
}

my-cliCJE-open(){
  atom $PSE_HOME
}

my-demo-cje-newWorkspace(){
  rm -rf $SUPPORT_CJE
  cd $GITHUB/cloudbees
  git clone git@github.com:cloudbees/support-cluster-cje.git
  cd $SUPPORT_CJE
}

my-demo-cje-blocked(){
  cd $SUPPORT_CJE
  echo "[my-INFO] updating project againts remote origin"
  git pull origin mastermy-profi
  echo "[my-INFO] Blocking the project"
  sh change_status.sh carlosr blocked
} 

my-demo-cje-not_blocked(){
  cd $SUPPORT_CJE
  echo "[my-INFO] Unblocking the project"
  sh change_status.sh carlosr not_blocked
} 

my-cbsupport-bundle-jenkins-test(){
  local testFolder="my-logsTest"
  if [ -z "$1" ];then
     echo "[my-ERROR]: type and ID (int number) for the test file"
  else
    local testLogFile="jenkins.test${1}.log"
    if [ -f "$testFolder/$testLogFile" ]; then
      echo "[my-ERROR]: $testLogFile already exists in $testFolder"
    else
      local msg=$2
      if [ -z "$msg" ];then
         echo "[my-ERROR]: A description of the test is needed"
      else 
        if [ ! -d "$testFolder" ]; then
          mkdir "$testFolder"
        fi 
        echo "=====================" >> $testFolder/$testLogFile
        echo "Test description: ${msg}" >> $testFolder/$testLogFile
        echo "=====================" >> $testFolder/$testLogFile
        nohup cbsupport-bundle-jenkins >> $testFolder/$testLogFile 2>&1
      fi
    fi
  fi
}

my-cbsupport-bundle-backUpJenkinsHome(){
  local backupFolder="my-backups"
  local manifestSB="manifest.md"
  local jenkinsHome="jenkins-home"
  local now=$(date +%d-%m-%Y-%M-%S)
  if [ -f "$manifestSB" ]; then
    if [ -d "$jenkinsHome" ]; then
      if [ ! -d "$backupFolder" ]; then
        mkdir "$backupFolder"
      fi
      tar -zcvf $backupFolder/$jenkinsHome-$now.tar.gz $jenkinsHome
    else 
      echo "[my-ERROR]: There is no $jenkinsHome to backup"
    fi
  else
    echo "[my-ERROR]: This is not a valid Support Bundle. There is no $manifestSB"
  fi
}

my-demo-cjp-ssh(){
  local USER="ubuntu"
  local MACHINE=$1
  local UNICORN_DOMAIN="unicorn.beescloud.com"
  local machine
  open -a Google\ Chrome https://cloudbees.atlassian.net/wiki/spaces/CJP/pages/51183799/CJP+Test+Environments
  while [[ $machine = "" ]]; do
      echo -n "[my-INFO]:please, specify a machine to connect to [ENTER]: "
      read machine
  done
  ssh $USER@$machine.$UNICORN_DOMAIN -i /Users/carlosrodlop/.aws/unicorn-team.pem
}

my-cbsupport-bundle-sshKeyPair(){
  # get fake seys from 
  local isSupportBundle="config.xml"
  local sshDirectory=".ssh"
  local sshName=$1
  if [ -f "$isSupportBundle" ]; then
     if [ -d "$sshDirectory" ]; then
      mkdir $sshDirectory
     fi
     while [[ $sshName = "" ]]; do
      echo -n "[my-INFO]: ssh key-pair name [ENTER]: " 
      read sshName
     done
     ssh-keygen -t rsa -C "$sshName" -f "$(pwd)/$sshDirectory/$sshName"
  else
     echo "[my-ERROR]: $(pwd) is not a JENKINS_HOME this function needs to be run inside it."
  fi  
} 

my-cbsupport-bundle-jnlpSlave(){
  #Docker Community Edition 18.03.0 - docker.for.mac.host.internal
  local dockerMacLocalhost="http://docker.for.mac.localhost"
  local secret
  local jenkinsPort
  local agentName
  while [[ $secret = "" ]]; do
      echo -n "[my-INFO]: JNLP secret [ENTER]: " 
      read secret
  done
  while [[ $agentName = "" ]]; do
      echo -n "[my-INFO]: agent name [ENTER]: " 
      read agentName
  done
  while [[ $jenkinsPort = "" ]]; do
      echo -n "[my-INFO]: Localhost Jenkins port [ENTER]: " 
      read jenkinsPort
  done
  docker run jenkinsci/jnlp-slave -url $dockerMacLocalhost:$jenkinsPort $secret $agentName
}

my-cbsupport-bundle-sshSlave(){
  my-cbsupport-bundle-sshKeyPair
  #ssh-copy-id -i ssh-slave-np  carlosrodlop@localhost 
  docker run -p 2022:22 jenkinsci/ssh-slave "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAep5NBklIoyh80PsCsvv3C6t/84yaSRurUjIquM7kjl9uxI1qJ2+VNwFRrom+SUzl0+BHHwJ3iFFKHH2R/zaRleWiA6yYZwIAohCX7SPpI0q5MzkyznliGu/sBenbkx+KDgrGXFFw1mmel19+2hsVz9YLZO+t2f7l4EqS5tUPllo4xEhmzs0LUjWWRTshBoCTOImZJAvKJA99yKH5hR8u+aiQljBJLVJ/I7LpqJz6O/Qy9FxPn38182W1mMZZp78UZWL/Sn7vlTNjIZhWNAi2OdN5ApaayUOgSESgN0fjCOPGbiKTFvUzzv0mUc2irgHNHj/Z0wykOZoOSc8x4ht/ ssh-slave-np"
}

my-cbsupport-bundle-analyzeSlowRequest(){
  ## Get number of calls 
  grep -h "elapsed in" $(pwd)/slow-requests/*  | awk '{print $6}' | sort | uniq -c | sort -n
  ## Get IPs
  grep -h "elapsed in" $(pwd)/slow-requests/*  | awk '{print $8}' | sort | uniq -c| sort -n
  ## Sort calls by ellapse time. TODO: It needas to get the last entry for each file
  grep -h "elapsed in" $(pwd)/slow-requests/* | sort -g
}
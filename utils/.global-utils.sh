#!/bin/bash

export globalUtilFile=$0

export bashrc=~/.bashrc

export baseUrl=https://raw.githubusercontent.com/lanshunfang/free-server/master/

# the top install folder
export freeServerRoot=~/free-server/

# utility folder
export utilDir=${freeServerRoot}/util

# for configration samples
export configDir=${freeServerRoot}/config

# temporary folder for installation
export freeServerRootTmp=${freeServerRoot}/tmp

export baseUrlUtils=${baseUrl}/utils
export baseUrlBin=${baseUrl}/bin
export baseUrlSetup=${baseUrl}/setup-tools

export oriConfigShadowsocksDir="/etc/shadowsocks-libev/"
export oriConfigShadowsocks="${oriConfigShadowsocksDir}/config.json"

export SPDYConfig="${configDir}/SPDY.conf"
export SPDYSSLKeyFile="${configDir}/SPDY.domain.key"
export SPDYSSLCertFile="${configDir}/SPDY.domain.crt"


function randomString()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}
export -f randomString

function echoS(){
  echo "***********++++++++++++++++++++++++++++++++++++++++++++++++++***********"
  echo "##"
  echo -e "## $1"
  echo "##"

  echo "***********++++++++++++++++++++++++++++++++++++++++++++++++++***********"

}
export -f echoS


function echoSExit(){
  echoS "$1"
  sleep 1
  exit 0
}
export -f echoSExit

function killProcessesByPattern(){
  echo -e "\nThe process(es) below would be killed"
  ps aux | gawk '/'$1'/ {print}' | cut -d" " -f 24-
  ps aux | gawk '/'$1'/ {print $2}' | xargs kill -9
  echo -e "\n\n"

}
export -f killProcessesByPattern

function removeWhiteSpace(){
  echo $(echo "$1" | gawk '{gsub(/ /, "", $0); print}')
}
export -f removeWhiteSpace

#####
# get interfact IP
#####
function getIp(){
  /sbin/ifconfig|grep 'inet addr'|cut -d':' -f2|awk '!/127/ {print $1}'
}
export -f getIp

#####
# download a file to folder
#
# @param String $1 is the url of file to downlaod
# @param String $2 is the folder to store
# @example downloadFileToFolder http://www.xiaofang.me/some.zip ~/free-server
#####
function downloadFileToFolder(){
  echo "Prepare to download file $1 into Folder $2"

  if [ ! -d "$2" ]; then
    echoS "Folder $2 is not existed. Exit"
    exit 0
  fi
  if [ -z $1 ]; then
    echoS "Url must be provided. Exit"
    exit 0
  fi
  wget -q --directory-prefix="$2" "$1"
}
export -f downloadFileToFolder



#####
# insert a line under the matched pattern
#
# @param String $1 is the file to operate
# @param RegExp String $2 is searching pattern for awk
# @param String $3 is line to insert to the found pattern
#####
function insertLineToFile(){

  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "$FUNCNAME FileName SearchingPattern LineToAdd"
    exit 0
  fi

  # all the arguments should be given
  if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]];then
    echo "You should provide all 3 arguments to invoke $$FUNCNAME"
    exit 1
  fi

  if [[ ! -f $1 ]]; then
    echo "File $1 is not existed"
    exit 1
  fi

  gawk -i inplace "/$2/ {print;print $3;next}1" $1

}
export -f insertLineToFile

#####
# replace a line with new line
#
# @param String $1 is the file to operate
# @param RegExp String $2 is searching pattern for awk
# @param String $3 is line to insert to the found pattern after the matched line removed
#####
function replaceLineInFile(){

  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "$FUNCNAME FileName SearchingPattern NewLine"
    exit 0
  fi

  # all the arguments should be given
  if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]];then
    echo "You should provide all 3 arguments to invoke $FUNCNAME"
    exit 1
  fi

  if [[ ! -f $1 ]]; then
    echo "File $1 is not existed"
    exit 1
  fi

  # find and remove the line matched to the pattern
  gawk -i inplace "{gsub(/$2/, $3)}; {print}" $1
}
export -f replaceLineInFile


#####
# replace a line with new line
#
# @param String $1 is the file to operate
# @param RegExp String $2 is searching pattern for awk
#####
function removeLineInFile(){

  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "$FUNCNAME FileName SearchingPattern"
    exit 0
  fi

  # all the arguments should be given
  if [[ -z $1 ]] || [[ -z $2 ]];then
    echo "You should provide all 2 arguments to invoke $$FUNCNAME"
    exit 1
  fi

  if [[ ! -f $1 ]]; then
    echo "File $1 is not existed"
    exit 1
  fi

  # find and remove the line matched to the pattern
  gawk -i inplace "!/$2/" $1
}
export -f removeLineInFile


#####
# Add date to String
#
# @param String $1 is the origin String
# @example file$(appendDateToString).bak
#####
function appendDateToString(){
  local now=$(date +"%m_%d_%Y")
  echo "-${now}"
}
export -f appendDateToString


#####
# Get User Input
#
# @param String $1 is the prompt
# @param String $2 file if the input must be a file, non-empty if the input must not empty
# @param Number $3 Max try times

# @example input=$(getUserInput "Provide File" file 3)
#####
function getUserInput(){

  promptMsg=$1
  inputValidator=$2
  maxtry=$3

  if [[ -z ${promptMsg} ]]; then
    echoS '@example input=$(getUserInput "Provide File" file 3)'
    exit 0
  fi

  if [[ -z ${maxtry} ]]; then
    maxtry=3
  fi

  while [ ${maxtry} -gt 0 ]; do

    sleep 1

    read -p "${promptMsg}" userinput
    userinput=$(removeWhiteSpace "${userinput}")

    if [[ "${inputValidator}" -eq "file" && ! -f "${userinput}" ]]; then
      echoS "The file ${userinput} you input is not existed. Retry"
    else
      break
    fi

    if [[ "${inputValidator}" -eq "non-empty" && -z "${userinput}" ]]; then
      echoS "Te input should not be empty. Retry"
    else
      break
    fi


    ((maxtry--))

  done

  echo ${userinput}


}
export -f getUserInput


#####
# Import MySQL db sql backup tar.gz to database
#
# @param String $1 is the backup folder to list
# @param String $2 is the database name
# @example importSqlTarToMySQL Folder
#####
function importSqlTarToMySQL(){

  dbFolder=$1

  if [[ ! -d ${dbFolder} ]]; then
    echoS "Folder ${dbFolder} is not existed"
    echoS "@example importSqlTarToMySQL ~/backup/"
    return 0
  fi

  echoS "Here is all the files found within folder ${dbFolder}\n"
  cd ${dbFolder}
  ls .

  echo -e "\n"

  dbTarGz=$(getUserInput "Input a *.tar.gz to import:  " "file")
  if [[ ! -f ${dbTarGz} || -z $(echo ${dbTarGz} | grep .gz) ]]; then
    echoS "${dbTarGz} is not a valid *.tar.gz file"
    exit 0
  fi

  # provide the db name to create
  dbName=$(getUserInput "the database name to import to:  " "non-empty")
  if [[  -z ${dbName} ]]; then
    exit 0
  fi

  # provide the new user name
  dbNewUser=$(getUserInput "The owner user name of database ${dbName} (Non-root):  " "non-empty")
  if [[  -z ${dbNewUser} ]]; then
    exit 0
  fi

  # provide password for the new user
  dbPass=$(getUserInput "input password for user ${dbNewUser} of Db ${dbName} (Non-root):  " "non-empty")
  if [[  -z ${dbPass} ]]; then
    exit 0
  fi


  # create user and grant
  echoS "Create new Db ${dbName} with Db user ${dbNewUser}."
  echoS "Provide MySQL root password:"

  sql="CREATE DATABASE IF NOT EXISTS ${dbName} ; \
  GRANT ALL PRIVILEGES ON ${dbName}.* To '${dbNewUser}'@'localhost' IDENTIFIED BY '${dbPass}';\
  FLUSH PRIVILEGES;"
  mysql -uroot -p -e "$sql"

  echoS "Exact ${dbTarGz}."
  rm -rf ~/__to_import > /dev/null
  mkdir -p ~/__to_import  > /dev/null
  tar zxf ${dbTarGz} -C ~/__to_import
  cd ~/__to_import  > /dev/null

  echoS "Importing. Provide MySQL root password:"
  mysql -uroot -p -h localhost ${dbName} < $(ls . | gawk '/\.sql/ {print}')

  rm -rf ~/__to_import
}
export -f importSqlTarToMySQL

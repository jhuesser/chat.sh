#!/bin/bash

#username = $USER

backlog=$1
 
  

function initalize {
  logifle=~/Library/Logs/chat.log
  msgType="input"
  #This is a textfile, on a remote server.
 
if [   -z  "$backlog"  ]
  then
	read -p "Enter the chatroom to join: " $backlog
  fi
   


}



function reload {
  #clears the console from the old backlog
  clear
  echo "----WELCOME $USER TO THE ROOM $backlog----"
  echo "----           REMEMBER TO BE NICE        ----"
  #backlog=`cat database.txt`

  #echo $backlog


  #writes $backlog to the console (getting from the textfile)
  cat $backlog



  readMsg

}

function composeFullMsg {

  final_msg="[$USER @ $DATE] $message"
  writeToFile
}

function readMsg {

  #Prompts a message where the user can write the message.
  echo "____________________________"
  echo $USER, "Write your message: "

  read message
  validateMsg


}

function writeStatus {

  case $msgType in
    status)
  final_msg="SYSTEM: $message"
  writeToFile
      ;;

    news)
  final_msg="+++ BREAKING NEWS: $message +++"
  writeToFile
  ;;


    esac
}

function syscommand {

  echo "____________________________"
  echo "$backlog type your system-message."

  read message
  msgType="status"
  writeStatus

}

function breakingNews {

  echo "____________________________"
  echo "Reporter $USER type your news"

  read message
  msgType="news"
  writeStatus

}

function validateMsg {

  #First check if the user wants to send e message or just refresh
  if [   -z  $message  ]
    then
    reload

  fi

  #In the next step we verify diffrent cases.

  case $message in
    /clear)
      rm -rf $backlog
      touch $backlog
      echo "------$backlog has been cleaned up by $USER-----">>$backlog
      reload
      ;;

    /clearAll)
      rm -rf $backlog
      touch $backlog
      echo "Silent cleanup executed succesfull"
      reload
      ;;

    /system)
      if [ $USER != root ]
        then
          echo "access denied. This will be reported!"
          logger "$USER tried /system command!"
        else
          syscommand


        fi
        reload
        ;;
      /breaking)
          breakingNews
          ;;


    *)
      getDate
    esac


}

function getDate {

  #Gets the actual date and format it (YYYY-MM-DD:hh:mm:ss)
  DATE=`date +%Y-%m-%d:%H:%M:%S`
  composeFullMsg
}

function writeToFile {

  #crafts the final message, username @ date and the message

  #Writes the final message to the textfile
  echo $final_msg>>$backlog
  #Adds a newline at the
  esed -i '' -e '$a\' $backlog
  reload
}



initalize
reload

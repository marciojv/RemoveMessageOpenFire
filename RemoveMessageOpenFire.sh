#!/bin/bash
# 
# RemoveMessageOpenFire
#
# version 1.0
#
# Copyright (C) 2010 Ambiente Livre Tecnologia / Marcio Junior Vieira
# All rights reserved.
# License: GNU/GPL License v2 or later.
# RemoveMessageOpenFire is free software. This version may have been modified pursuant
# to the GNU General Public License, and as distributed it includes or
# is derivative of works licensed under the GNU General Public License or
# other free or open source software licenses.
# http://www.ambientelivre.com.br
#
# Help and Support in http://www.ambientelivre.com.br/RemoveMessageOpenFire.html
# 
# sponsorship of this program was provided by the Brazilian company CDC Brasil http://www.cdcbrasil.com.br
# by Hans Cofré <hans @ cdcbrasil.com.br>



# *********** Config Script **************************#
CLASSPATH_OPENFIRE=/usr/share/openfire/lib/hsqldb.jar # add HSQLDB JarFile Path 
RCFILE=/home/marcio/embedded-db.rc                    # add rcfile Path 
BDHSQL=embedded-db                                    # add OpenFire DataBase Name,


#*********** Args ************************************#
IDMESSAGE=$2

# ************* SQL SCRIPTS **************************#

#SQL For list conversations by ID

# list conversation openfire
SQLLISTCONVERSATIONID="SELECT CONVERSATIONID, FROMJID, TOJID, SENTDATE, BODY FROM OfMessageArchive WHERE CONVERSATIONID = $IDMESSAGE"

# remove all tables com history this conversation

SQLDELCONVERSATIONID="DELETE FROM OfMessageArchive WHERE CONVERSATIONID = $IDMESSAGE; DELETE FROM Ofconparticipant WHERE CONVERSATIONID = $IDMESSAGE; DELETE FROM OfConversation WHERE CONVERSATIONID = $IDMESSAGE;commit;shutdown;" 


function helpprogram {
   clear
   echo "Usage: RemoveMessageOpenFire  [OPTIONNAME] [IDMESSAGE]"
   echo ""
   echo "   -l      list conversation"
   echo "   -r      remove messagen"
   echo "   -h      show this help"
   echo ""
   echo " author: Marcio Junior Vieira                    "
   echo ""
   echo "Sample"
   echo ""
   echo "- remove conversation 45 in openFire DataBase"
   echo "$ ./RemoveMessageOpenFire -r 45"
   echo ""
   echo "please: execute whith database stop and see the configuration variables at the beginning of this script with his ways, and also has a set rcfile"
   echo ""
   echo "Send email to in case of bugs : < marcio @ ambientelivre.com.br >"
   echo "Ambiente Livre Tecnologia - Open Source Solution"
   echo "http://www.ambientelivre.com.br"
   echo ""
   echo " Help Support in http://www.ambientelivre.com.br/RemoveMessageOpenFire.html"
}


function sintax { echo "Usage: RemoveMessageOpenFire [-l|-f|-h] [idmessage]"
}

if [ $# -lt 1 ] ; then echo "RemoveMessageOpenFire: Invalid number of parameters" ; sintax ; exit ; fi
if [ $# -lt 2 ] && [ "$1" = "-l" ] ; then echo "RemoveMessageOpenFire: Invalid number of parameters" ; sintax ; exit ; fi
if [ $# -lt 2 ] && [ "$1" = "-r" ] ; then echo "RemoveMessageOpenFire: Invalid number of parameters" ; sintax ; exit ; fi
if [ $# -gt 2 ] ; then echo "RemoveMessageOpenFire: Invalid number of parameters" ; sintax ; exit ; fi


#********************************************
# fun�ao acionada quando op�ao inv�lida
#********************************************
function help { echo "RemoveMessageOpenFire: option Invalid $1" ;echo "try \`RemoveMessageOpenFire -h' for help."
}

#*********************************************
# options 
#*********************************************

while getopts "lrha" option 2>>/dev/null
  do
    case $option in
      a | h ) helpprogram ;;
      l ) java -cp $CLASSPATH_OPENFIRE org.hsqldb.util.SqlTool --autoCommit --sql "$SQLLISTCONVERSATIONID" --rcfile "$RCFILE" $BDHSQL ;;
      r ) java -cp $CLASSPATH_OPENFIRE org.hsqldb.util.SqlTool --autoCommit --sql "$SQLDELCONVERSATIONID"  --rcfile "$RCFILE" $BDHSQL ;;
      * ) help $1 ;;
    esac
  done


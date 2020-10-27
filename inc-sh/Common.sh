#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  3.2.0
# Modified: 24-Oct-2020
#
# This include defines some global variables and functions that could be used in any project script.
#
# These globals can be referenced within config payloads by the use of %% characters
# For example the global GLB_SV_ADDNSDOMAINNAME can be referenced like this %SV_ADDNSDOMAINNAME%
#
# Defines the following globals:
#
#  GLB_IV_THISSCRIPTSTARTEPOCH            - When the script started running
#  GLB_SV_THISSCRIPTDIRPATH               - Directory location of running script
#  GLB_SV_THISSCRIPTFILEPATH              - Full source path of running script
#  GLB_SV_THISSCRIPTFILENAME              - filename of running script
#  GLB_SV_THISSCRIPTNAME                  - Filename without extension
#  GLB_IV_THISSCRIPTPID                   - Process ID of running script
#
#  GLB_SV_THISSCRIPTTEMPDIRPATH           - Temporary Directory for the currently running script
#  GLB_SV_RUNUSERTEMPDIRPATH              - Temporary Directory for the current user
#
#  GLB_SV_RUNUSERNAME                     - The name of the user that is running this script
#  GLB_IV_RUNUSERID                       - The user ID of the user that is running this script
#  GLB_BV_RUNUSERISADMIN                  - Whether the user running this script is an admin (true/false)
#
#  GLB_SV_MODELIDENTIFIER                 - Model ID, i.e. MacBookPro5,4
#
#  GLB_IV_BUILDVERSIONSTAMPASNUMBER       - The build version represented as a number, i.e. 14F1808 translates to 29745664
#  GLB_SV_BUILDVERSIONSTAMPASSTRING       - The build version represented as a string, i.e. 14F1808
#  GLB_IV_SYSTEMVERSIONSTAMPASNUMBER      - The system version represented as a number, i.e. 10.10.5 translates to 168428800
#  GLB_SV_SYSTEMVERSIONSTAMPASSTRING      - The system version represented as a string, i.e. 10.10.5
#
#  GLB_SV_IPV4PRIMARYSERVICEUUID          - A uuid like 9804EAB2-718C-42A7-891D-79B73F91CA4B
#  GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15  - The domain advertised by DHCP
#  GLB_SV_IPV4PRIMARYSERVICEINTERFACENAME - i.e. Wi-Fi
#  GLB_SV_IPV4PRIMARYSERVICEDEVICENAME    - i.e. en1
#  GLB_SV_IPV4PRIMARYSERVICEHARDWARENAME  - i.e. Airport
#
#  GLB_SV_HOSTNAME                        - i.e. the workstation name
#
#  GLB_SV_ADFLATDOMAINNAME                - Flat AD domain, i.e. YOURDOMAIN
#  GLB_SV_ADDNSDOMAINNAME                 - FQ AD domain, i.e. yourdomain.yourcompany.com
#  GLB_SV_ADCOMPUTERNAME                  - This should be the same as the workstation name
#  GLB_SV_ADTRUSTACCOUNTNAME              - This is the account used by the workstation for AD services - i.e. workstationname$
#
# And when GLB_SV_RUNUSERNAME=root, the following global is also defined
#  GLB_SV_ADTRUSTACCOUNTPASSWORD          - This is the password used by the workstation for AD services
#
# These globals are set to the default values, if they are null
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
#  GLB_SV_LOGFILEPATH                     - Location of the active log file
#
# Defines the following LabWarden functions:
#
#  GLB_IF_SYSTEMIDLESECS                                                   - Get the number of seconds that there has been no mouse or keyboard activity
#  GLB_SF_ORIGINALFILEPATH <FilePathString>                                - Get the original file path; resolving any links
#  GLB_NF_SCHEDULE4EPOCH <TagString> <WakeTypeString> <EpochInt>           - Schedule a "wake" or "poweron" wake type for the given epoch
#  GLB_SF_URLENCODE <String>                                               - URL decode function - REFERENCE https://gist.github.com/cdown/1163649
#  GLB_SF_URLDECODE <String>                                               - URL encode function - REFERENCE https://gist.github.com/cdown/1163649
#  GLB_SF_EXPANDGLOBALSINSTRING <String>                                   - Replace %GLOBAL% references within a string with their GLB_GLOBAL values
#  GLB_SF_LOGLEVEL <LogLevelInt>                                           - Convert log level integer into log level text
#  GLB_NF_LOGMESSAGE <LogLevelInt> <MessageText>                           - Output message text to the log file
#  GLB_NF_SHOWNOTIFICATION <LogLevelInt> <MessageText>                     - Show a pop-up notification
#  GLB_BF_NAMEDLOCKGRAB <LockNameString> <MaxSecsInt> <SilentFlagBool>     - Grab a named lock
#  GLB_NF_NAMEDLOCKRELEASE <LockNameString> <MaxSecsInt> <SilentFlagBool>  - Release a named lock
#  GLB_NF_NAMEDFLAGCREATE <FlagNameString>                                 - Create a named flag. FlagNameString can be anything you like.
#  GLB_NF_NAMEDFLAGTEST <FlagNameString>                                   - Test if a named flag exists
#  GLB_NF_NAMEDFLAGDELETE <FlagNameString>                                 - Delete a named flag
#  GLB_NF_QUICKEXIT <ReasonString>                                         - Quickly exit the running script and log the reason string
#  GLB_IF_GETPLISTARRAYSIZE <plistfile> <property>                         - Get an array property size from a plist file
#  GLB_NF_SETPLISTPROPERTY <plistfile> <property> <value>                  - Set a property to a value in a plist file
#  GLB_NF_RAWSETPLISTPROPERTY<plistfile> <property> <value>                - Set a property to a value in a plist file, without checking that the value sticks
#  GLB_SF_GETPLISTPROPERTY <plistfile> <property> [defaultvalue]           - Get a property value from a plist file
#  GLB_SF_DELETEPLISTPROPERTY <plistfile> <property>                       - Delete a property from a plist file
#
#  Key:
#    GLB_ - LabWarden global variable
#
#    bc_ - string constant with the values 'true' or 'false'
#    ic_ - integer constant
#    sc_ - string constant
#
#    bv_ - string variable with the values 'true' or 'false'
#    iv_ - integer variable
#    sv_ - string variable
#
#    nf_ - null function    (doesn't return a value)
#    bf_ - boolean function (returns string values 'true' or 'false'
#    if_ - integer function (returns an integer value)
#    sf_ - string function  (returns a string value)
#

# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---
  
# Only run the code if it hasn't already been run
if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
then
    
  # ---
  
  # Include the constants library (if it is not already loaded)
  if [ -z "${GLB_BC_CONST_ISINCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/Constants.sh

    # Exit if something went wrong unexpectedly
    if test -z "${GLB_BC_CONST_ISINCLUDED}"
    then
      echo >&2 "Something unexpected happened"
      exit 90
    fi
  fi

  # -- Begin Function Definition --
  
  # Convert log level integer into log level text
  GLB_SF_LOGLEVEL()   # loglevel
  {  
    local iv_LogLevel
    local sv_LogLevel
    
    iv_LogLevel=${1}
    
    case ${iv_LogLevel} in
    ${GLB_IC_MSGLEVELEMERG})
      sv_LogLevel="Emergency"
      ;;
      
    ${GLB_IC_MSGLEVELALERT})
      sv_LogLevel="Alert"
      ;;
      
    ${GLB_IC_MSGLEVELCRIT})
      sv_LogLevel="Critical"
      ;;
      
    ${GLB_IC_MSGLEVELERR})
      sv_LogLevel="Error"
      ;;
      
    ${GLB_IC_MSGLEVELWARN})
      sv_LogLevel="Warning"
      ;;
      
    ${GLB_IC_MSGLEVELNOTICE})
      sv_LogLevel="Notice"
      ;;
      
    ${GLB_IC_MSGLEVELINFO})
      sv_LogLevel="Information"
      ;;
      
    ${GLB_IC_MSGLEVELDEBUG})
      sv_LogLevel="Debug"
      ;;
      
    *)
      sv_LogLevel="Unknown"
      ;;
      
    esac
    
    echo ${sv_LogLevel}
  }
  
  # Save a message to the log file
  GLB_NF_LOGMESSAGE()   # intloglevel strmessage
  {
    local iv_LogLevel
    local sv_Message
    local sv_LogDirPath
    local sv_LogFileName
    local sv_LogLevel
    local sv_WorkingDirPath
    local iv_LoopCount
    local iv_EmptyBackupIndex
    
    iv_LogLevel=${1}
    sv_Message="${2}"
    
    if [ -n "${GLB_SV_LOGFILEPATH}" ]
    then
    
      # Get dir of log file
      sv_LogDirPath="$(dirname "${GLB_SV_LOGFILEPATH}")"
  
      # Get filename of this script
      sv_LogFileName="$(basename "${GLB_SV_LOGFILEPATH}")"
  
      if test -z "${GLB_IV_LOGLEVELTRAP}"
      then
        # Use the hard-coded value if the value is not set
        GLB_IV_LOGLEVELTRAP=${GLB_IV_DFLTLOGLEVELTRAP}
      fi
    
      if [ "${GLB_BV_LOGISACTIVE}" = "${GLB_BC_TRUE}" ]
      then
        mkdir -p "${sv_LogDirPath}"

        if [ ${iv_LogLevel} -le ${GLB_IV_LOGLEVELTRAP} ]
        then
        
          # Backup log if it gets too big
          if [ -e "${GLB_SV_LOGFILEPATH}" ]
          then
            if [ $(stat -f "%z" "${GLB_SV_LOGFILEPATH}") -gt ${GLB_IV_LOGSIZEMAXBYTES} ]
            then
              if [ "$(GLB_BF_NAMEDLOCKGRAB "BackupLog" 0 ${GLB_BC_TRUE})" = ${GLB_BC_TRUE} ]
              then
                mv -f "${GLB_SV_LOGFILEPATH}" "${GLB_SV_LOGFILEPATH}.bak"
                for (( iv_LoopCount=0; iv_LoopCount<=8; iv_LoopCount++ ))
                do
                  if [ ! -e "${GLB_SV_LOGFILEPATH}.${iv_LoopCount}.tgz" ]
                  then
                    break
                  fi
                done
    
                iv_EmptyBackupIndex=${iv_LoopCount}
    
                for (( iv_LoopCount=${iv_EmptyBackupIndex}; iv_LoopCount>0; iv_LoopCount-- ))
                do
                  mv -f "${GLB_SV_LOGFILEPATH}.$((${iv_LoopCount}-1)).tgz" "${GLB_SV_LOGFILEPATH}.${iv_LoopCount}.tgz"
                done
    
                sv_WorkingDirPath="$(pwd)"
                cd "${sv_LogDirPath}"
                tar -czf "${sv_LogFileName}.0.tgz" "${sv_LogFileName}.bak"
                rm -f "${sv_LogFileName}.bak"
                cd "${sv_WorkingDirPath}"
              fi
              GLB_NF_NAMEDLOCKRELEASE "BackupLog" ${GLB_BC_TRUE}
            fi
          fi
  
          # Make the log entry
          sv_LogLevel="$(GLB_SF_LOGLEVEL ${iv_LogLevel})"
          echo "$(date '+%d %b %Y %H:%M:%S %Z') ${GLB_SV_THISSCRIPTFILENAME}[${GLB_IV_THISSCRIPTPID}]${GLB_SV_CODEVERSION}: ${sv_LogLevel}: ${sv_Message}"  >> "${GLB_SV_LOGFILEPATH}"
          echo >&2 "$(date '+%d %b %Y %H:%M:%S %Z') ${GLB_SV_THISSCRIPTFILENAME}[${GLB_IV_THISSCRIPTPID}]${GLB_SV_CODEVERSION}: ${sv_LogLevel}: ${sv_Message}"

        fi
      fi
    fi    
  }
  
  GLB_BF_NAMEDLOCKGRAB() # ; LockName [MaxSecs] [SilentFlag]; 
  # LockName can be anything - LabWarden root user uses gpupdate, gpo-mobileconfig
  # MaxSecs is the max number of secs to wait for lock
  # SilentFlag, if true then lock activity is not logged
  # Returns 'true' or 'false'
  {
    local sv_LockName
    local sv_MaxSecs
    local sv_LockDirPath
    local iv_Count
    local sv_ActiveLockPID
    local bv_Result
    local bv_SilentFlag

    sv_LockName="${1}"
    sv_MaxSecs="${2}"
    if test -z "${sv_MaxSecs}"
    then
      sv_MaxSecs=10
    fi
      
    bv_SilentFlag="${3}"
    if test -z "${bv_SilentFlag}"
    then
      bv_SilentFlag=${GLB_BC_FALSE}
    fi
    
    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"
    mkdir -p "${sv_LockDirPath}"
 
    bv_Result=${GLB_BC_FALSE}
    while [ "${bv_Result}" = ${GLB_BC_FALSE} ]
    do
      if ! test -s "${sv_LockDirPath}/${sv_LockName}"
      then
        echo "${GLB_IV_THISSCRIPTPID}" > "${sv_LockDirPath}/${sv_LockName}"
      fi
      # Ignore errors, because the file might disappear before we get a chance to do the cat
      sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
      if [ "${sv_ActiveLockPID}" = "${GLB_IV_THISSCRIPTPID}" ]
      then
        if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Grabbed lock '${sv_LockName}'"
        fi
        bv_Result=${GLB_BC_TRUE}
        break
      fi
      
      iv_LockEpoch=$(stat 2>/dev/null -f "%m" "${sv_LockDirPath}/${sv_LockName}")
      if [ $? -gt 0 ]
      then
        # another task may have deleted the lock while we weren't looking
        iv_LockEpoch=$(date -u "+%s")
      fi
      if [ $(($(date -u "+%s")-${iv_LockEpoch})) -ge ${sv_MaxSecs} ]
      then
        if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Grab lock failed, another task is being greedy '${sv_LockName}'"
        fi
        break
      fi 
           
      if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
      then
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Waiting for lock '${sv_LockName}'"
      fi
      sleep 1
    done
    
    echo "${bv_Result}"
  }  

  GLB_NF_NAMEDLOCKMEPOCH() # ; LockName
  {
    local sv_LockName
    local sv_LockDirPath
    local iv_LockEpoch

    sv_LockName="${1}"
    
    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"

    if test -e "${sv_LockDirPath}/${sv_LockName}"
    then
      iv_LockEpoch=$(stat 2>/dev/null -f "%m" "${sv_LockDirPath}/${sv_LockName}")
      if [ $? -gt 0 ]
      then
        # another task may have deleted the lock while we weren't looking
        iv_LockEpoch=0
      fi
    else
      iv_LockEpoch=0
    fi
    
    echo ${iv_LockEpoch}
  }

  GLB_NF_NAMEDLOCKRELEASE() # ; LockName
  {
    local sv_LockName
    local sv_LockDirPath
    local sv_ActiveLockPID
    local bv_SilentFlag

    sv_LockName="${1}"

    bv_SilentFlag="${2}"
    if test -z "${bv_SilentFlag}"
    then
      bv_SilentFlag=${GLB_BC_FALSE}
    fi
    
    sv_LockDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Locks"

    if test -s "${sv_LockDirPath}/${sv_LockName}"
    then
      sv_ActiveLockPID="$(cat 2>/dev/null "${sv_LockDirPath}/${sv_LockName}" | head -n1)"
      if [ "${sv_ActiveLockPID}" = "${GLB_IV_THISSCRIPTPID}" ]
      then
        if [ "${bv_SilentFlag}" = ${GLB_BC_FALSE} ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Releasing lock '${sv_LockName}'"
        fi
        rm -f "${sv_LockDirPath}/${sv_LockName}"
      fi
    fi
  }  

  GLB_NF_NAMEDFLAGCREATE() # ; FlagName [epoch]
  # FlagName can be anything - LabWarden root user uses Restart, Shutdown
  {
    local sv_FlagName
    local sv_FlagDirPath

    sv_FlagName="${1}"
    sv_Epoch="${2}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    mkdir -p "${sv_FlagDirPath}"
    
    if [ -z "${sv_Epoch}" ]
    then
      touch "${sv_FlagDirPath}/${sv_FlagName}"
    else
      touch -t $(date -r ${sv_Epoch} "+%Y%m%d%H%M.%S") "${sv_FlagDirPath}/${sv_FlagName}"
    fi
    
    chown "$(whoami)" "${sv_FlagDirPath}/${sv_FlagName}"
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Creating flag '${sv_FlagDirPath}/${sv_FlagName}'"
  }

  GLB_NF_NAMEDFLAGMEPOCH() # ; FlagName
  {
    local sv_FlagName
    local sv_FlagDirPath
    local iv_FlagEpoch

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"

    if test -e "${sv_FlagDirPath}/${sv_FlagName}"
    then
      iv_FlagEpoch=$(stat -f "%m" "${sv_FlagDirPath}/${sv_FlagName}")
    else
      iv_FlagEpoch=0
    fi
    
    echo ${iv_FlagEpoch}
  }

  GLB_NF_NAMEDFLAGTEST()
  {
    local sv_FlagName
    local sv_FlagDirPath
    local sv_Result
    local sv_FlagOwner

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Testing flag '${sv_FlagDirPath}/${sv_FlagName}'"
    sv_Result=${GLB_BC_FALSE}
    if test -e "${sv_FlagDirPath}/${sv_FlagName}"
    then
      sv_FlagOwner=$(stat -f '%Su' "${sv_FlagDirPath}/${sv_FlagName}")
      if [ "${sv_FlagOwner}" = "$(whoami)" ]
      then
        sv_Result=${GLB_BC_TRUE}
      fi
    fi
    
    echo "${sv_Result}"
  }

  GLB_NF_NAMEDFLAGDELETE()
  {
    local sv_FlagName
    local sv_FlagDirPath

    sv_FlagName="${1}"
    
    sv_FlagDirPath="${GLB_SV_RUNUSERTEMPDIRPATH}/Flags"
    
    rm -f "${sv_FlagDirPath}/${sv_FlagName}"
#    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "Deleting flag '${sv_FlagDirPath}/${sv_FlagName}'"
  }

  GLB_NF_QUICKEXIT()   # Quickly exit the running script 
  {
    if test -n "${1}"
    then
      if test -n "${2}"
      then
        GLB_NF_LOGMESSAGE ${2} "${1}"
      else
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELINFO} "${1}"
      fi
    fi
    
    # Remove temporary files
    cd "${GLB_SV_PROJECTDIRPATH}"
    rm -fR "${GLB_SV_THISSCRIPTTEMPDIRPATH}"
    
    exit 99
  }

  # NOTE: if things go wrong, this function and code that uses this function, are good places to look
  GLB_SF_GETDIRECTORYOBJECTATTRVALUE()   # context name attr - given an array property name, returns the size of the array 
  {
    local sv_ObjectContext
    local sv_ObjectName
    local sv_Attr
    local sv_Value
    local sv_Attr
  
    sv_ObjectContext="${1}"
    sv_ObjectName="${2}"
    sv_Attr="${3}"

    sv_Value="$(dscl 2>/dev/null localhost -read "${sv_ObjectContext}/${sv_ObjectName}" ${sv_Attr})"
    iv_Err=$?
    if [ ${iv_Err} -gt 0 ]
    then
      echo "ERROR"
      
    else
      echo "${sv_Value}" | sed "s|^[^:]*:${sv_Attr}:|${sv_Attr}:|" | tr -d "\r" | tr "\n" "\r" | sed 's|'${sv_Attr}':||'g | tail -n1 | tr "\r" "\n" | sed '/^\s*$/d' | sed 's|^[ ]*||'g

    fi
  }
  
  GLB_IF_GETPLISTARRAYSIZE()   # plistfile property - given an array property name, returns the size of the array 
  {
    local sv_PlistFilePath
    local sv_PropertyName
  
    sv_PlistFilePath="${1}"
    sv_PropertyName="${2}"
  
    /usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | grep -E "$(/usr/libexec/PlistBuddy 2>/dev/null -c "Print ':${sv_PropertyName}'" "${sv_PlistFilePath}" | grep -E "^ " | head -n1 | sed "s|\(^[ ]*\)\([^ ]*.*\)|\^\1\\[\^ }\]|")" | wc -l | sed "s|^[ ]*||"
  }









      
  # -- End Function Definition --
  
  # Take a note when this script started running
  GLB_IV_THISSCRIPTSTARTEPOCH=$(date -u "+%s")
  
  
  
  # -- Get some info about this script
  
  # Full source of this script
  GLB_SV_THISSCRIPTFILEPATH="${0}"
  
  # Get dir of this script
  GLB_SV_THISSCRIPTDIRPATH="$(dirname "${GLB_SV_THISSCRIPTFILEPATH}")"
  
  # Get filename of this script
  GLB_SV_THISSCRIPTFILENAME="$(basename "${GLB_SV_THISSCRIPTFILEPATH}")"
  
  # Filename without extension
  GLB_SV_THISSCRIPTNAME="$(echo ${GLB_SV_THISSCRIPTFILENAME} | sed 's|\.[^.]*$||')"
  
  # Get Process ID of this script
  GLB_IV_THISSCRIPTPID=$$
  
  
  # -- Get some info about the running user
  
  # Get user name
  GLB_SV_RUNUSERNAME="$(whoami)"
  
  # Get user ID
  GLB_IV_RUNUSERID="$(id -u ${GLB_SV_RUNUSERNAME})"
  
  # Check if user is an admin (returns 'true' or 'false')
  if [ "$(dseditgroup -o checkmember -m "${GLB_SV_RUNUSERNAME}" -n . admin | cut -d" " -f1)" = "yes" ]
  then
    GLB_BV_RUNUSERISADMIN=${GLB_BC_TRUE}
  else
    GLB_BV_RUNUSERISADMIN=${GLB_BC_FALSE}
  fi

  # Get the Run User Home directory
  GLB_SV_RUNUSERHOMEDIRPATH=$(echo ~/)
  

  
  # -- Get some info about logging

  # If necessary, setup the location of the log file
  
  if [ -z "${GLB_SV_LOGFILEPATH}" ]
  then
    if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
    then
      GLB_SV_LOGFILEPATH="/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
  
    else
      GLB_SV_LOGFILEPATH="${GLB_SV_RUNUSERHOMEDIRPATH}/Library/Logs/${GLB_SC_PROJECTSIGNATURE}.log"
    
    fi
  fi

  # -- Create temporary directories

  # The base locations of all temporary directories
  GLB_SV_TEMPROOT="/tmp/${GLB_SC_PROJECTNAME}"
  GLB_AV_TEMPUSERSROOT="${GLB_SV_TEMPROOT}/Users"
  
  # Create base temporary directories
  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then
    mkdir -p "${GLB_SV_TEMPROOT}"
    chown root:wheel "${GLB_SV_TEMPROOT}"
    chmod 1755 "${GLB_SV_TEMPROOT}"

    mkdir -p "${GLB_AV_TEMPUSERSROOT}"
    chown root:wheel "${GLB_AV_TEMPUSERSROOT}"
    chmod 1777 "${GLB_AV_TEMPUSERSROOT}"
  fi
    
  # Create a temporary directory private to this user (and admins)
  GLB_SV_RUNUSERTEMPDIRPATH=${GLB_AV_TEMPUSERSROOT}/${GLB_SV_RUNUSERNAME}
  if ! test -d "${GLB_SV_RUNUSERTEMPDIRPATH}"
  then
    mkdir -p "${GLB_SV_RUNUSERTEMPDIRPATH}"
    chown ${GLB_SV_RUNUSERNAME}:admin "${GLB_SV_RUNUSERTEMPDIRPATH}"
    chmod 770 "${GLB_SV_RUNUSERTEMPDIRPATH}"
  fi
  
  # Create a temporary directory private to this script
  GLB_SV_THISSCRIPTTEMPDIRPATH="$(mktemp -dq ${GLB_SV_RUNUSERTEMPDIRPATH}/${GLB_SV_THISSCRIPTFILENAME}-XXXXXXXX)"
  
  
  # -- Get workstation name
  
  GLB_SV_HOSTNAME=$(hostname -s)

  # -- Get AD workstation name (the name when it was bound)
  
  # Get Computer AD trust account - i.e. yourcomputername$
  GLB_SV_ADTRUSTACCOUNTNAME="$(dsconfigad 2>/dev/null -show | grep "Computer Account" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # AD computer name (without the trailing dollar sign)
  GLB_SV_ADCOMPUTERNAME=$(echo ${GLB_SV_ADTRUSTACCOUNTNAME} | sed "s|\$$||")
  
  # ---
  
  # Get Computer full AD domain - i.e. yourdomain.yourcompany.com
  GLB_SV_ADDNSDOMAINNAME="$(dsconfigad 2>/dev/null -show | grep "Active Directory Domain" | sed "s|\([^=]*\)=[ ]*\([^ ]*$\)|\2|")"
  
  # ---
  
  # If the workstation is bound to AD, make sure the computer name matches the AD object
  if test -n "${GLB_SV_ADCOMPUTERNAME}"
  then
    if [ "${GLB_SV_HOSTNAME}" != "${GLB_SV_ADCOMPUTERNAME}" ]
    then
      GLB_SV_HOSTNAME="${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setcomputername "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set ComputerName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/systemsetup -setlocalsubnetname "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set LocalHostName "${GLB_SV_ADCOMPUTERNAME}"
      /usr/sbin/scutil --set HostName "${GLB_SV_ADCOMPUTERNAME}.${GLB_SV_ADDNSDOMAINNAME}"
    
    fi
  fi
  
  # ---
  
  # Get Computer short AD domain - i.e. YOURDOMAIN
  if test -n "${GLB_SV_ADDNSDOMAINNAME}"
  then
    # If we have just started up, we may need to wait a short time while the system populates the scutil vars
    iv_DelayCount=0
    while [ ${iv_DelayCount} -lt 5 ]
    do
      GLB_SV_ADFLATDOMAINNAME=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameFlat" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
      if test -n "${GLB_SV_ADFLATDOMAINNAME}"
      then
        break
      fi
  
      # we don't want to hog the CPU - so lets sleep a while
      GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELNOTICE} "Waiting around until the scutil ActiveDirectory vars are populated"
      sleep 1
        
      iv_DelayCount=$((${iv_DelayCount}+1))
    done
  fi
  
  # --
  
  # Get Computer AD trust account password
  if test -n "${GLB_SV_ADTRUSTACCOUNTNAME}"
  then
    GLB_SV_ADTRUSTACCOUNTPASSWORD=$(security find-generic-password -w -s "/Active Directory/${GLB_SV_ADFLATDOMAINNAME}" /Library/Keychains/System.keychain)
  fi
  
  # -- Get Network info
  
  GLB_SV_IPV4PRIMARYSERVICEUUID=$(echo "show State:/Network/Global/IPv4" | scutil | grep "PrimaryService" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  if test -n "${GLB_SV_IPV4PRIMARYSERVICEUUID}"
  then
    # Get DHCP option 15 (domain)
    GLB_SV_IPV4PRIMARYSERVICEDHCPOPTION15=$(echo "show State:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/DHCP" | scutil | grep "Option_15" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||" | sed -E "s/^<data> 0x//;s/00$//" | xxd -r -p)
  
    # Get user defined name - e.g. Wi-Fi
    GLB_SV_IPV4PRIMARYSERVICEINTERFACENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}" | scutil | grep "UserDefinedName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device name - e.g. en1
    GLB_SV_IPV4PRIMARYSERVICEDEVICENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "DeviceName" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  
    # Get device hardware - e.g. Airport
    GLB_SV_IPV4PRIMARYSERVICEHARDWARENAME=$(echo "show Setup:/Network/Service/${GLB_SV_IPV4PRIMARYSERVICEUUID}/Interface" | scutil | grep "Hardware" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")
  fi
  
  # Get the the device name for wireless (eg en1)
  GLB_SV_WIFIINTERFACEDEVICE="$(networksetup -listallhardwareports | tr "\n" ":" | sed "s|^[:]*||;s|::|;|g" | tr ";" "\n" | grep "Wi-Fi" | sed "s|\(.*Device:[ ]*\)\([^:]*\)\(.*\)|\2|" | head -n 1)"
  
  # -- Get some info about the OS

  # Last OS X version would probably be 10.255.25 (259Z2047)
  
  # Calculate BuildVersionStampAsNumber
  
  GLB_SV_BUILDVERSIONSTAMPASSTRING="$(sw_vers -buildVersion)"
  
  # Split build version (eg 14A379a) into parts (14,A,379,a)
  iv_BuildMajorNum=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|[a-zA-Z][0-9]*||;s|[a-zA-Z]*$||")
  sv_BuildMinorChar=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*||;s|[0-9]*[a-zA-Z]*$||")
  iv_BuildRevisionNum=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*[a-zA-Z]||;s|[a-zA-Z]*$||")
  sv_BuildStageChar=$(echo ${GLB_SV_BUILDVERSIONSTAMPASSTRING} | sed "s|^[0-9]*[a-zA-Z][0-9]*||")
  
  iv_BuildMinorNum=$(($(printf "%d" "'${sv_BuildMinorChar}")-65))
  if [ -n "${sv_BuildStageChar}" ]
  then
    iv_BuildStageNum=$(($(printf "%d" "'${sv_BuildStageChar}")-96))
  else
    iv_BuildStageNum=0
  fi
  
  GLB_IV_BUILDVERSIONSTAMPASNUMBER=$((((${iv_BuildMajorNum}*32+${iv_BuildMinorNum})*2048+${iv_BuildRevisionNum})*32+${iv_BuildStageNum}))
  
  # Calculate SystemVersionStampAsNumber
  
  GLB_SV_SYSTEMVERSIONSTAMPASSTRING="$(sw_vers -productVersion)"
  
  GLB_IV_SYSTEMVERSIONSTAMPASNUMBER=0
  for iv_Num in $(echo ${GLB_SV_SYSTEMVERSIONSTAMPASSTRING}".0.0.0.0" | cut -d"." -f1-4 | tr "." "\n")
  do
    GLB_IV_SYSTEMVERSIONSTAMPASNUMBER=$((${GLB_IV_SYSTEMVERSIONSTAMPASNUMBER}*256+${iv_Num}))
  done
  
  # -- Get the number of CPU cores

  GLB_SV_HWNCPU="$(sysctl -n hw.ncpu)"
  
  # ---
  
  GLB_BC_COMM_ISINCLUDED=${GLB_BC_TRUE}

fi

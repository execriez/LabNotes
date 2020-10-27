#!/bin/bash
#
# Short:    Common routines (shell)
# Author:   Mark J Swift
# Version:  3.2.0
# Modified: 24-Oct-2020
#
# This include defines some global variables and functions that are used in core scripts and utilities.
# These variables and functions are not used the policy scripts, unless passed to the policy on the command line.
#
# Defines the following globals:
#
#  GLB_SC_PROJECTSETTINGSDIRPATH          - Top level path to where LabWarden config files are stored
#  GLB_SV_SYSDEFAULTSCONFIGFILEPATH       - System defaults payload file path
#
#  GLB_BV_USELOGINHOOK                    - Whether we should use the com.apple.loginwindow LoginHook & LogoutHook (true/false)
#  GLB_IV_GPFORCEUPDATEMINMINUTES         - How old the policies need to be for gpupdate -force to do updates
#  GLB_IV_GPQUICKUPDATEMINMINUTES         - How old the policies need to be for gpupdate -quick to do updates
#  GLB_IV_GPUPDATEMINMINUTES              - How old the policies need to be for gpupdate to do updates
#
#  GLB_BV_LOGISACTIVE                     - Whether we should log (true/false) 
#  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
#  GLB_IV_LOGLEVELTRAP                    - The logging level (see GLB_iv_MsgLevel...)
#  GLB_IV_NOTIFYLEVELTRAP                 - The user notify dialog level
#  GLB_SV_LOGFILEPATH                     - Location of the active log file
#
#  GLB_SV_LOGINFO                         - LOGISACTIVE;LOGLEVELTRAP;LOGSIZEMAXBYTES;LOGFILEPATH
#
#  GLB_SV_LOCALPREFSDIRPATH               - Directory location of the local prefs file
#  GLB_SV_GLOBALPREFSDIRPATH              - Directory location of the global prefs file
#
#  GLB_IV_CONSOLEUSERID                   - The user ID of the logged-in user
#
#  GLB_BV_CONSOLEUSERISADMIN              - Whether the logged-in user is an admin (true/false)
#  GLB_BV_CONSOLEUSERISLOCAL              - Whether the logged-in user account is local (true/false)
#  GLB_BV_CONSOLEUSERISMOBILE             - Whether the logged-in user account is mobile (true/false)
#
#  GLB_BV_CONSOLEUSERHOMEISLOCAL          - Whether the logged-in user home is on a local drive (true/false)
#  GLB_SV_CONSOLEUSERHOMEDIRPATH          - Home directory for the logged-in user
#  GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH     - Local home directory for the logged-in user (in /Users)
#  GLB_SV_CONSOLEUSERSHAREDIRPATH         - Network home directory path, i.e. /Volumes/staff/t/testuser
#
#  GLB_SV_CONSOLEUSERINFO                 - USERNAME;USERID;USERISADMIN;USERISLOCAL;USERISMOBILE;HOMEISLOCAL;HOMEDIRPATH;LOCALHOMEDIRPATH;NETWORKHOMEDIRPATH
#
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

# ---
  
# Assume that all code is run from a subdirectory of the main project directory
GLB_SV_PROJECTDIRPATH="$(dirname $(dirname ${0}))"

# ---

if [ -z "${GLB_BC_CORE_ISINCLUDED}" ]
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

  # ---
  
  # Location where the config/pref files are stored
  GLB_SC_PROJECTSETTINGSDIRPATH="/Library/Preferences/SystemConfiguration/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}"
  
  # Location of the system defaults file
  GLB_SV_SYSDEFAULTSCONFIGFILEPATH="${GLB_SC_PROJECTSETTINGSDIRPATH}/Config/Global/Sys-Defaults.plist"
  
  # ---

  # Include the Common library (if it is not already loaded)
  if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
  then
    . "${GLB_SV_PROJECTDIRPATH}"/inc-sh/Common.sh

    # Exit if something went wrong unexpectedly
    if [ -z "${GLB_BC_COMM_ISINCLUDED}" ]
    then
      echo >&2 "Something unexpected happened"
      exit 90
    fi
  fi

  # By the time we get here, quite a few global variables have been set up.
  # Look at 'inc/Common.sh' for a complete list.

  # -- Begin Function Definition --

  # -- End Function Definition --
  


  # -- Get some info about the logged in user
  
  # Only allow specifying a different logged in user, if we are root
  if [ "${GLB_SV_RUNUSERNAME}" != "root" ]
  then
    GLB_SV_CONSOLEUSERNAME="${GLB_SV_RUNUSERNAME}"
  fi

  if test -n "${GLB_SV_CONSOLEUSERNAME}"
  then

    # Get user ID
    GLB_IV_CONSOLEUSERID="$(id -u ${GLB_SV_CONSOLEUSERNAME})"
  
    # Check if user is an admin (returns 'true' or 'false')
    if [ "$(dseditgroup -o checkmember -m "${GLB_SV_CONSOLEUSERNAME}" -n . admin | cut -d" " -f1)" = "yes" ]
    then
      GLB_BV_CONSOLEUSERISADMIN=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISADMIN=${GLB_BC_FALSE}
    fi
  
    # Where would the user home normally be if it were local
    if [ "${GLB_SV_CONSOLEUSERNAME}" = "root" ]
    then
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="/var/root"
  
    else
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="/Users/${GLB_SV_CONSOLEUSERNAME}"
      
    fi
  
    # Get the User Home directory
    GLB_SV_CONSOLEUSERHOMEDIRPATH=$(eval echo ~${GLB_SV_CONSOLEUSERNAME})
    
    # Make sure that we got a valid home
    if test -n "$(echo ${GLB_SV_CONSOLEUSERHOMEDIRPATH} | grep '~')"
    then
      GLB_SV_CONSOLEUSERHOMEDIRPATH="/Users/${GLB_SV_CONSOLEUSERNAME}"
    fi
  
    # Decide whether the user home is on the local drive
    if test -n "$(stat -f "%Sd" "${GLB_SV_CONSOLEUSERHOMEDIRPATH}" | grep "^disk")"
    then
      GLB_BV_CONSOLEUSERHOMEISLOCAL=${GLB_BC_TRUE}
      GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH="${GLB_SV_CONSOLEUSERHOMEDIRPATH}"
      
    else
      GLB_BV_CONSOLEUSERHOMEISLOCAL=${GLB_BC_FALSE}
      
    fi
  
    # Check if user is a local account (returns 'true' or 'false')
    if [ "$(dseditgroup -o checkmember -m "${GLB_SV_CONSOLEUSERNAME}" -n . localaccounts | cut -d" " -f1)" = "yes" ]
    then
      GLB_BV_CONSOLEUSERISLOCAL=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISLOCAL=${GLB_BC_FALSE}
    fi
  
    #  Get the local accounts 'OriginalHomeDirectory' property
    sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Local/Default/Users" "${GLB_SV_CONSOLEUSERNAME}" "OriginalHomeDirectory")
    if [ "${sv_Value}" = "ERROR" ]
    then
      sv_Value=""
    fi

    if test -n "${sv_Value}"
    then
      GLB_BV_CONSOLEUSERISMOBILE=${GLB_BC_TRUE}
    else
      GLB_BV_CONSOLEUSERISMOBILE=${GLB_BC_FALSE}
    fi
  
    # Get the network defined home directory
    if [ "${GLB_BV_CONSOLEUSERISLOCAL}" = ${GLB_BC_FALSE} ]
    then
      # - Network account -
  
      # Get UserHomeNetworkURI 
      # eg: smb://yourserver.com/staff/t/testuser
      # or  smb://yourserver.com/Data/Student%20Homes/Active/teststudent
  
      #  Get 'SMBHome' property
      sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "SMBHome")
      if [ "${sv_Value}" = "ERROR" ]
      then
        sv_Value=""
      fi
      
      # We are only interested in one entry
      sv_Value=$(echo ${sv_Value} | head -n1)
      
      if [ -n "${sv_Value}" ]
      then
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "SMBHome ${sv_Value}"
        # Check for characters that we may not have considered
        sv_CheckString=$(GLB_SF_URLENCODE "${sv_Value}" | sed 's|%5c|\\|g;s|%20| |g')
        if [ "${sv_CheckString}" != "${sv_Value}" ]
        then
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELWARN} "Unexpected characters in SMBHome property ${sv_Value}"
        fi
        # Prepend the preferred protocol
        sv_PropertyString="Network protocol to be used";sv_protocol=$(dsconfigad -show | grep "${sv_PropertyString}" | cut -d "=" -f2 | sed "s|^[ ]*||;s|[ ]*$||")
        if test -z "${sv_protocol}"
        then
          sv_protocol="smb"
        fi
        GLB_SV_CONSOLEUSERSHAREURI=$(GLB_SF_URLENCODE "${sv_Value}" | sed "s|%5c|/|g"| sed "s|^[/]*|${sv_protocol}://|")
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERSHAREURI ${GLB_SV_CONSOLEUSERSHAREURI}"

      else
        #  Get 'HomeDirectory' property
        sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "HomeDirectory")
        if [ "${sv_Value}" = "ERROR" ]
        then
          sv_Value=""
        fi
      
        # We are only interested in one entry
        sv_Value=$(echo ${sv_Value} | head -n1)
      
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "HomeDirectory ${sv_Value}"
        GLB_SV_CONSOLEUSERSHAREURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")
        if test -z "${GLB_SV_CONSOLEUSERSHAREURI}"
        then
          #  Get 'OriginalHomeDirectory' property
          sv_Value=$(GLB_SF_GETDIRECTORYOBJECTATTRVALUE "/Search/Users" "${GLB_SV_CONSOLEUSERNAME}" "OriginalHomeDirectory")
          if [ "${sv_Value}" = "ERROR" ]
          then
            sv_Value=""
          fi
      
          # We are only interested in one entry
          sv_Value=$(echo ${sv_Value} | head -n1)
      
          GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "OriginalHomeDirectory ${sv_Value}"
          GLB_SV_CONSOLEUSERSHAREURI=$(echo "${sv_Value}" | sed "s|<[^>]*>||g;s|/$||;s|^[^:]*:||")    
        fi  
        GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERSHAREURI ${GLB_SV_CONSOLEUSERSHAREURI}"
      fi
    
      if test -n "${GLB_SV_CONSOLEUSERSHAREURI}"
      then
        # Get full path to the network HomeDirectory 
        # ie: /Volumes/staff/t/testuser
        # or  /Volumes/Data/Student Homes/Active_Q2/pal/teststudpal
        while read sv_MountEntry
        do
          sv_MountPoint=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\2|' | grep -v '^/$')
          sv_MountShare=$(echo ${sv_MountEntry} | sed -E 's|(^.*) on (.*) (\(.*\))|\1|' | sed 's|'${GLB_SV_CONSOLEUSERNAME}'@||')
          if test -n "$(echo "${GLB_SV_CONSOLEUSERSHAREURI}" | sed "s|^[^:]*:||" | grep -E "^${sv_MountShare}")"
          then
            sv_ConsoleUserHomeNetworkDirPath=$(GLB_SF_URLDECODE "${sv_MountPoint}$(echo ${GLB_SV_CONSOLEUSERSHAREURI} | sed "s|^[^:]*:||;s|^"${sv_MountShare}"||")")
            if test -e "${sv_ConsoleUserHomeNetworkDirPath}"
            then
              GLB_SV_CONSOLEUSERSHAREDIRPATH="${sv_ConsoleUserHomeNetworkDirPath}"
              break
            fi
          fi
        done < <(mount | grep "//${GLB_SV_CONSOLEUSERNAME}@")
      
      fi
    fi
    
    GLB_SV_CONSOLEUSERINFO="${GLB_SV_CONSOLEUSERNAME};${GLB_IV_CONSOLEUSERID};${GLB_BV_CONSOLEUSERISADMIN};${GLB_BV_CONSOLEUSERISLOCAL};${GLB_BV_CONSOLEUSERISMOBILE};${GLB_BV_CONSOLEUSERHOMEISLOCAL};${GLB_SV_CONSOLEUSERHOMEDIRPATH};${GLB_SV_CONSOLEUSERLOCALHOMEDIRPATH};${GLB_SV_CONSOLEUSERSHAREURI};${GLB_SV_CONSOLEUSERSHAREDIRPATH}"
    GLB_NF_LOGMESSAGE ${GLB_IC_MSGLEVELDEBUG} "GLB_SV_CONSOLEUSERINFO ${GLB_SV_CONSOLEUSERINFO}"

  fi

  # ---
  
  # Decide the location of the preferences
  if [ "${GLB_SV_RUNUSERNAME}" = "root" ]
  then
    GLB_SV_LOCALPREFSDIRPATH="${GLB_SC_PROJECTSETTINGSDIRPATH}/Config/Computers/localhost"
  
  else
    GLB_SV_LOCALPREFSDIRPATH="${GLB_SV_CONSOLEUSERHOMEDIRPATH}/Library/Preferences/${GLB_SC_PROJECTSIGNATURE}/V${GLB_SC_PROJECTMAJORVERSION}/${GLB_SV_HOSTNAME}"
    
  fi
  
  GLB_SV_GLOBALPREFSDIRPATH="${GLB_SC_PROJECTSETTINGSDIRPATH}/Config/Global"

  # ---

  GLB_SV_LOGINFO="${GLB_BV_LOGISACTIVE};${GLB_IV_LOGLEVELTRAP};${GLB_IV_LOGSIZEMAXBYTES};${GLB_SV_LOGFILEPATH}"

  # ---

  GLB_BC_CORE_ISINCLUDED=${GLB_BC_TRUE}

fi

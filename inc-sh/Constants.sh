#!/bin/bash
#
# Short:    Constants (shell)
# Author:   Mark J Swift
# Version:  3.2.0
# Modified: 24-Oct-2020
#
# Should be included into scripts as follows:
#   . /usr/local/LabWarden/inc-sh/Constants.sh
#

# Only INCLUDE the code if it isn't already included
if [ -z "${GLB_BC_CONST_ISINCLUDED}" ]
then

  # Defines the following LabWarden global constants:
  #
  #  GLB_BC_TRUE                            - the value 'true'
  #  GLB_BC_FALSE                           - the value 'false'
  #
  #  GLB_SC_PROJECTNAME                     - Project name (LabWarden)
  #  GLB_SC_PROJECTINITIALS                 - Project initials (LW)
  #  GLB_SC_PROJECTDEVELOPER                - Project developer (com.github.execriez)
  #  GLB_SC_PROJECTVERSION                  - Project version (i.e. 2.0.6)
  #
  #  GLB_SC_PROJECTSIGNATURE                - Project signature (e.g. com.github.execriez.labwarden)
  #  GLB_SC_PROJECTMAJORVERSION             - Project major version (i.e. 2)
  #
  #
  #  GLB_IC_MSGLEVELEMERG                   - (0) Emergency, system is unusable
  #  GLB_IC_MSGLEVELALERT                   - (1) Alert, should be corrected immediately
  #  GLB_IC_MSGLEVELCRIT                    - (2) Critical, critical conditions (some kind of failure in the systems primary function)
  #  GLB_IC_MSGLEVELERR                     - (3) Error, error conditions
  #  GLB_IC_MSGLEVELWARN                    - (4) Warning, may indicate that an error will occur if no action is taken
  #  GLB_IC_MSGLEVELNOTICE                  - (5) Notice, events that are unusual, but not error conditions
  #  GLB_IC_MSGLEVELINFO                    - (6) Informational, normal operational messages that require no action
  #  GLB_IC_MSGLEVELDEBUG                   - (7) Debug, information useful for developing and debugging
  #
  #  GLB_BV_LOGISACTIVE                     - Whether we should log by default (true/false) 
  #  GLB_IV_LOGSIZEMAXBYTES                 - Maximum length of LabWarden log(s)
  #
  #  GLB_IV_LOGLEVELTRAP                    - Sets the default logging level (see GLB_iv_MsgLevel...)
  #  GLB_IV_NOTIFYLEVELTRAP                 - Set the default user notify dialog level
  #
  #  GLB_IV_GPFORCEUPDATEMINMINUTES         - How old the policies need to be for gpupdate -force to do updates
  #  GLB_IV_GPQUICKUPDATEMINMINUTES         - How old the policies need to be for gpupdate -quick to do updates
  #  GLB_IV_GPUPDATEMINMINUTES              - How old the policies need to be for gpupdate to do updates
  #
  #  Key:
  #    GLB_ - global variable
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
  
  # Fixed constants
  
  GLB_BC_TRUE="true"
  GLB_BC_FALSE="false"

  GLB_IC_MSGLEVELEMERG=0
  GLB_IC_MSGLEVELALERT=1
  GLB_IC_MSGLEVELCRIT=2
  GLB_IC_MSGLEVELERR=3
  GLB_IC_MSGLEVELWARN=4
  GLB_IC_MSGLEVELNOTICE=5
  GLB_IC_MSGLEVELINFO=6
  GLB_IC_MSGLEVELDEBUG=7

  # Project version and naming constants

  GLB_SC_PROJECTNAME="LabNotes"
  GLB_SC_PROJECTINITIALS="LN"
  GLB_SC_PROJECTVERSION="3.2.0"
  GLB_SC_PROJECTMAJORVERSION="3"
  GLB_SC_PROJECTDEVELOPER="com.github.execriez"
  GLB_SC_PROJECTSIGNATURE="com.github.execriez.labnotes"
  
  GLB_SV_PROJECTINSTALLTYPE="full"

  # gpupdate -force updates when policies are older than 1 minute
  GLB_IV_GPFORCEUPDATEMINMINUTES=1

  # gpupdate -quick updates when policies are older than 180 days
  GLB_IV_GPQUICKUPDATEMINMINUTES=259200

  # gpupdate defaults to update policies when they are older than 6 hours old
  GLB_IV_GPUPDATEMINMINUTES=360
  
  # Set whether the log is on by default
  GLB_BV_LOGISACTIVE=${GLB_BC_TRUE}

  # Set the maximum log size
  GLB_IV_LOGSIZEMAXBYTES=655360
  
  # -- Set some values based on the above constamts
    
  # Set the logging level
  GLB_IV_LOGLEVELTRAP=${GLB_IC_MSGLEVELINFO}
  
  # Set the user notify dialog level
  GLB_IV_NOTIFYLEVELTRAP=${GLB_IC_MSGLEVELINFO}
  
  # ---
  
  GLB_BC_CONST_ISINCLUDED=${GLB_BC_TRUE}
  
  # --- 
fi

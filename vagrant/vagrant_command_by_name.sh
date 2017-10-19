#!/bin/bash

#
#    Copyright 2017 Konstantin Fedorov
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

#******************************************************************************#
#                                                                              #
#   vagrant_command_by_name.sh                                                 #
#                                                                              #
#   Author: Fedorov Konstantin (mr.fedorov.konstantin@mail.ru)                 #
#   Created: 18.10.2017                                                        #
#                                                                              #
#   Script for running vagrant commands by VM name from anywhere               #
#                                                                              #
#                                                                              #
#  Call with:                                                                  #
#    vagrant_command_by_name.sh <command> <VM_name>                            #
#  exit codes:                                                                 #
#    0  - on success                                                           #
#    64 - on invalid args                                                      #
#    65 - on VM search errors                                                  #
#    66 - on VM string parse errors                                            #
#    67 - on vagrant command run fails                                         #
#    68 - on vagrant command not supported                                     #
#  notes:                                                                      #
#    call from anywhere                                                        #
#    VM must exist (created)                                                   #
#    we do not parse Vagrantfile, we rely on 'vagrant global-status'           #
#                                                                              #
#******************************************************************************#


# -- vars
# error code range: 64 - 113
E_OK=0
E_ERROR=1
E_INVALID_ARGS=64
E_VM_SEARCH=65
E_VM_STRING_PARSE=66
E_VAGRANT_COMMAND_RUN=67
E_VAGRANT_COMMAND_NOT_SUPPORTED=68

#vagrant_pattern="(UID)\s*(NAME)\s*(PROVIDER)\s*(STATUS)\s*(PATH))"
# egrep doesnt regognize \w
#vagrant_pattern="([A-Za-z0-9]{7})\s*([-\w]+)\s*(virtualbox|vmware)\s*(running|poweroff)\s*([-\w\.\\\/]+)"

# generic parsing pattern
pattern="([A-Za-z0-9]{7})\s+([A-Za-z0-9_-]+)\s+(virtualbox|vmware)\s+(poweroff|running)\s+([-_A-Za-z0-9\.\\\/]+)"

# -- vars


# --- get vagrant command as arg1
if [ -z "$1" ]
then
  echo -e "ARG1 MISSED. vagrant command is required to proceed."
  exit ${E_INVALID_ARGS}
else
  vagrant_command=$1
  echo -e "Use vagrant command: ${vagrant_command}"  # debug info
fi
# --- get vagrant command as arg1

# --- get VM name as arg2
if [ -z "$2" ]
then
  echo -e "ARG2 MISSED. VM name is required to proceed."
  exit ${E_INVALID_ARGS}
else
  vm_name=$2
  echo -e "Use VM name: ${vm_name}"  # debug info
fi
# --- get VM name as arg2


#
# -- vars
#

# construct pattern with imprinted VM name
pattern_imprinted_vm_name="([A-Za-z0-9]{7})\s+(${vm_name})\s+(virtualbox|vmware)\s+(poweroff|running)\s+([-_A-Za-z0-9\.\\\/]+)"
echo; echo -e "constructed pattern: ${pattern_imprinted_vm_name}"; echo;  # debug info

#global_name=`vagrant global-status | grep -e "vg_win7-opcjson"`

is_running=$(vagrant global-status | egrep "${pattern_imprinted_vm_name}")
#echo $is_running; echo;  # debug info

# -- vars



if [ -z "$is_running" ]
then
  # var is empty, VM not created
  echo -e "result: VM not present or not created"
  exit ${E_VM_SEARCH}
else
  # var not empty
  echo -e "result: VM present"  # debug info
  echo -e "string: $is_running"  # debug info
fi

echo;

#
# string present, now we can parse it
#

if [[ $is_running =~ $pattern ]]
then

  echo "pattern matched, string: $is_running"  # debug info
  echo -e "Number of BASH_REMATCH array elements: ${#BASH_REMATCH[@]}"  # debug info

  vm_string=${BASH_REMATCH[0]}
  vm_UID=${BASH_REMATCH[1]}
  vm_NAME=${BASH_REMATCH[2]}
  vm_PROVIDER=${BASH_REMATCH[3]}
  vm_STATUS=${BASH_REMATCH[4]}
  vm_PATH=${BASH_REMATCH[5]}

  echo -e "Full capture string: ${vm_string}"  # debug info
  echo -e "element 1, VM UID: ${vm_UID}"  # debug info
  echo -e "element 2, VM NAME: ${vm_NAME}"  # debug info
  echo -e "element 3, VM PROVIDER: ${vm_PROVIDER}"  # debug info
  echo -e "element 4, VM STATUS: ${vm_STATUS}"  # debug info
  echo -e "element 5, VM PATH: ${vm_PATH}"  # debug info
  echo  # debug info

else
  echo -e "no match"
  exit ${E_VM_STRING_PARSE}
fi

#
# string parsed, now we can do commands
#

echo -e "Gonna run: vagrant ${vagrant_command} ${vm_UID}"


# run command 
echo -e "command: $1"  # debug info
case "$1" in
"status")
  # -- run
  if vagrant ${vagrant_command} ${vm_UID}
  then
    echo -e "Command run successful"
    exit ${E_OK}
  else
    echo -e "Run FAIL"
    exit ${E_VAGRANT_COMMAND_RUN}
  fi
  # -- run
;;
"halt")
  # -- run
  if vagrant ${vagrant_command} ${vm_UID}
  then
    echo -e "Command run successful"
    exit ${E_OK}
  else
    echo -e "Run FAIL"
    exit ${E_VAGRANT_COMMAND_RUN}
  fi
  # -- run
;;
"port")
  # -- run
  if vagrant ${vagrant_command} ${vm_UID}
  then
    echo -e "Command run successful"
    exit ${E_OK}
  else
    echo -e "Run FAIL"
    exit ${E_VAGRANT_COMMAND_RUN}
  fi
  # -- run
;;
"ssh")
  # -- run
  if vagrant ${vagrant_command} ${vm_UID}
  then
    echo -e "Command run successful"
    exit ${E_OK}
  else
    echo -e "Run FAIL"
    exit ${E_VAGRANT_COMMAND_RUN}
  fi
  # -- run
;;
"up")
  # because Vagrantfile is required for up command
  # changing dir to vagrant VM folder
  cd ${vm_PATH}
  # -- run
  if vagrant ${vagrant_command} ${vm_UID}
  then
    echo -e "Command run successful"
    # changing dir back
    cd -
    exit ${E_OK}
  else
    echo -e "Run FAIL"
    # changing dir back
    cd -
    exit ${E_VAGRANT_COMMAND_RUN}
  fi
  # -- run
;;
*)
  echo -e "Command not supported."
  exit ${E_VAGRANT_COMMAND_NOT_SUPPORTED}
;;
esac


#
## ALL DONE

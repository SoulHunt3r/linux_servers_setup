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
#   vagrant_vm_get_name.sh                                                     #
#                                                                              #
#   Author: Fedorov Konstantin (mr.fedorov.konstantin@mail.ru)                 #
#   Created: 19.10.2017                                                        #
#                                                                              #
#   Script that return Vagrant VM name                                         #
#                                                                              #
#                                                                              #
#  Call with:                                                                  #
#    vagrant_vm_get_name.sh                                                    #
#  return:                                                                     #
#    VM name on success                                                        #
#  exit codes:                                                                 #
#    0  - on success                                                           #
#    64 - no Vagrantfile in dir we called it                                   #
#    65 - vagrant status output not matched search pattern                     #
#  notes:                                                                      #
#    call from VM dir                                                          #
#    VM must exist (or at least Vagrantfile)                                   #
#    we do not parse Vagrantfile, we rely on 'vagrant status' command output   #
#    output does not contain newline symbols                                   #
#                                                                              #
#******************************************************************************#


# -- vars
# error code range: 64 - 113
E_OK=0
E_ERROR=1
E_NO_VAGRANTFILE=64
E_NO_PATTERN_MATCH=65

# generic parsing pattern
pattern="([A-Za-z0-9_-]+)\s+(poweroff|running|not created)\s+\((virtualbox|vmware)\)"

# command to run
is_present=$(vagrant status)
#echo $is_present; echo  # debug info
# -- vars


# run command
if [ -z "$is_present" ]
then
  # var is empty, no Vagrant file
#  echo -e "result: status failed. Vagrant file not present"; echo -e ${is_present}; echo $PWD; echo
  exit ${E_NO_VAGRANTFILE}
#else
  # var not empty
#  echo -e "result: VM present"; echo -e "string: $is_present"; echo  # debug info
fi


#
# string present, now we can parse it
#
if [[ $is_present =~ $pattern ]]
then
#  echo "pattern matched, string: $is_present"  # debug info
#  echo -e "Number of BASH_REMATCH array elements: ${#BASH_REMATCH[@]}"  # debug info

  vm_string=${BASH_REMATCH[0]}
  vm_NAME=${BASH_REMATCH[1]}
  vm_STATUS=${BASH_REMATCH[2]}
  vm_PROVIDER=${BASH_REMATCH[3]}

#  echo -e "Full capture string: ${vm_string}"
#  echo -e "element 1, VM NAME: ${vm_NAME}"
#  echo -e "element 2, VM STATUS: ${vm_STATUS}"
#  echo -e "element 3, VM PROVIDER: ${vm_PROVIDER}"
#  echo

  echo -ne ${vm_NAME}
  exit ${E_OK}
else
#  echo -e "no match"
  exit ${E_NO_PATTERN_MATCH}
fi


#
## ALL DONE


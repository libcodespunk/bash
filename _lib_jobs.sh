# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_JOBS ]] &&
   return
_H_CODESPUNK_BASH_JOBS=true

## ##

function _jobs_get_count_e {
   jobs -r | wc -l | tr -d " "
}

function _jobs_set_max_parallel {
   g_jobs_max_jobs=$1
}

function _jobs_get_max_parallel_e {
   [[ $g_jobs_max_jobs ]] && {
      echo $g_jobs_max_jobs

      return 0
   }

   echo 1
}

function _jobs_is_parallel_available_r() {
   (( $(_jobs_get_count_e) < $g_jobs_max_jobs )) &&
      return 0

   return 1
}

function _jobs_wait_parallel() {
   # Sleep between available jobs
   while true; do
      _jobs_is_parallel_available_r &&
         break

      sleep 0.1s
   done
}

function _jobs_wait() {
   wait
}

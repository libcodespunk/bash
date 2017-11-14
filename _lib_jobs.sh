# LICENSE
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details
# at http://www.gnu.org/copyleft/gpl.html
# 
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

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

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

function _goto {
    local $__goto_label=$1
    
    eval "$(sed -n "/$__goto_label:/{:a;n;p;ba};" $0 | grep -v ':$')"
    
    # Necessary?
    exit
}

# start=${1:-"start"}

# jumpto $start

# start:
# # your script goes here...
# x=100
# jumpto foo

# mid:
# x=101
# echo "This is not printed!"

# foo:
# x=${x:-10}
# echo x is $x

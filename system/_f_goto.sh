# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
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

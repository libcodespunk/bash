# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

__script_path=${BASH_SOURCE[0]%/*}

! [[ -f $__script_path ]] ||
   [[ $__script_path = */* ]] ||
      __script_path=.

pushd "$__script_path" 1>/dev/null
popd 1>/dev/null

__LIB_COREUTILS_SCRIPT_PATH=$OLDPWD

source "$__LIB_COREUTILS_SCRIPT_PATH/libcoreutils/_basename.sh" || exit 1
source "$__LIB_COREUTILS_SCRIPT_PATH/libcoreutils/_dirname.sh" || exit 1

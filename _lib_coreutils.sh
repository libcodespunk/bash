# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_COREUTILS ]] &&
   return
_H_CODESPUNK_BASH_COREUTILS=true

[[ $CODESPUNK_HOME ]] || {
   >&2 echo A required environment variable is set to an invalid directory.
   >&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
   >&2 echo Please configure your environment to include the location of your \
   libcodespunk installation.
   
   exit 1
}

source "$CODESPUNK_HOME/bash/libcoreutils/_basename.sh" || exit 1
source "$CODESPUNK_HOME/bash/libcoreutils/_dirname.sh" || exit 1

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

__LIB_ECLIPSE_SCRIPT_PATH=$OLDPWD

source "$__LIB_ECLIPSE_SCRIPT_PATH/_lib_echo.sh" || exit 1
source "$__LIB_ECLIPSE_SCRIPT_PATH/_lib_exception.sh" || exit 1
source "$__LIB_ECLIPSE_SCRIPT_PATH/_lib_os.sh" || exit 1
source "$__LIB_ECLIPSE_SCRIPT_PATH/_lib_require.sh" || exit 1

# Allow only tested operating systems to run this script
case $(_os_get_system_name_e) in
cygwin);;
darwin);;
linux);;
*)
   _print_stacktrace_e "Unsupported or unknown operating system"
   exit 1;;
esac

# Verify required script dependencies
type -P sed &>/dev/null ||
   _require_add "cut"
   
type -P sed &>/dev/null ||
   _require_add "head"
   
type -P readlink &>/dev/null ||
   _require_add "readlink"
   
type -P sed &>/dev/null ||
   _require_add "sed"
   
if ! echo a | grep -Pq a &>/dev/null; then
   # Check for non-standard macports ggrep
   if ! echo a | ggrep -Pq a &>/dev/null; then
      _require_add "grep with Perl-compatible REGEX"
   else
      function grep() {
         ggrep "$@"
      }
   fi
fi

_require_report_r ||
   exit 1

# $1 : Full eclipse path to executable
function _eclipse_has_plugin_cdt_r() {
   local eclipse_path="$(dirname $1)"
   local eclipse_exec="$(basename $1)"
   
   cdt="org.eclipse.cdt.managedbuilder.core_"
   ! [[ "$(find "$eclipse_path/plugins" -name "$cdt*" -print -quit)" ]] &&
      return 1
}

# $1 : Path to query as workspace
function _eclipse_is_path_a_workspace_r() {
   grep -iq -m1 "org.eclipse" "$1/.metadata/version.ini" &>/dev/null ||
      return 1
}

# $1 : Path to eclipse executable directory
function _eclipse_get_default_workspace_e() {
   local prefs="$1/configuration/.settings/org.eclipse.ui.ide.prefs"
   local recent
   local default
   
   # Prefs file does not exist
   if ! [ -f "$prefs" ]; then
      return 1
   fi
   
   # A list of recent workspaces known by eclipse separated by a delimiter "\n"
   recent="$(grep -i "^RECENT_WORKSPACES=" "$prefs" | cut -d'=' -f2)"
   
   # No recent workspaces
   if ! [[ $recent ]]; then
      return 1
   fi
   
   # The presence of the string literal "\n" delimiter signifies that there are
   # multiple recent workspaces known to eclipse
   if echo $recent | grep -Pq '(?<!\\)\\n'; then
      split=$(echo $recent | grep -Paob '(?<!\\)\\n' | head -n1 | cut -d':' -f1)
      
      # The most recent workspace substring
      default="${recent:0:$split}"
   else
      default="$recent"
   fi
   
   # Parse out escaped ':' and double backslashes '\\' from Windows path
   if [[ $(_os_get_system_name_e) = cygwin ]]; then
      default="$(
         echo $default | sed 's/\\:/:/g' | sed 's/\\\\/\\/g'
      )"
   fi
   
   echo $default
}

function _eclipse_exec_r {
   local eclipse_path="$1"; shift
   local eclipse_exec="$1"; shift
   
   case $(_os_get_system_name_e) in
   darwin)
      # Use symlink to executable, not the .app file
      eclipse_exec="eclipse"
   esac
   
   "$eclipse_path/$eclipse_exec" $@ ||
      return 1;
}

function _eclipse_exec_nohup {
   local eclipse_path="$1"; shift
   local eclipse_exec="$1"; shift
   
   case $(_os_get_system_name_e) in
   cygwin)
      run "$eclipse_path/$eclipse_exec" $@;;
   darwin)
      open -a "$eclipse_path/$eclipse_exec" $@;;
   linux)
      nohup "$eclipse_path/$eclipse_exec" $@;;
   esac
}

function _eclipse_import_project_r {
   if ! _eclipse_has_plugin_cdt_r "$eclipse_path/$eclipse_exec"; then
      _print_stacktrace_e "Importing projects requires the 'Eclipse CDT \
      (C/C++ Development Tools) plugin to be installed."
         
      return 1
   fi
   
   case $(_os_get_system_name_e) in
   cygwin)
      "$eclipse_path/$eclipse_exec" \
      -nosplash \
      -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
      -import "$@" \
         || return 1;;
   darwin)
      # Use symlink to executable, not the .app file
      eclipse_exec="eclipse"
      
      "$eclipse_path/$eclipse_exec" \
      -nosplash \
      -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
      -import "$@" \
         || return 1;;
   linux)
      "$eclipse_path/$eclipse_exec" \
      -nosplash \
      -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
      -import "$@" \
         || return 1;;
   esac
}

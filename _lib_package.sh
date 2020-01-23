# LICENSE
# 
# The contents of this file are subject to the terms of the Mozilla Public
# License, version 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/.
# 
# Author: Matthew D'Onofrio (http://codespunk.com)

[[ $_H_CODESPUNK_BASH_PACKAGE ]] &&
   return
_H_CODESPUNK_BASH_PACKAGE=true

[[ $CODESPUNK_HOME ]] || {
   >&2 echo A required environment variable is set to an invalid directory.
   >&2 echo CODESPUNK_HOME = \"$CODESPUNK_HOME\"
   >&2 echo Please configure your environment to include the location of your \
   libcodespunk installation.
   
   exit 1
}

source "$CODESPUNK_HOME/bash/_lib_require.sh" || exit 1
source "$CODESPUNK_HOME/bash/system/_f_md5.sh" || exit 1

## ##

__package_head=$(cat <<EOF
#!/bin/sh
[ $prefix ] || prefix=/usr/local

_busybox_has() {
   if ! [ $__g_lib_package_busybox_exists ]; then
      if ! busybox 2>/dev/null >/dev/null; then
         return 1
      else
         __g_lib_package_busybox_exists=true
      fi
   fi
   
   # Sanitize searches for '[' and '[['
   a=$(echo $1 | sed 's/[[]/\\[/g')

   busybox | grep -oqe "[[:space:]]\(mesg\)\([,]\|\$\)" ||
      return 1
}

_awk() {
   if ! [ $g_avail_awk ]; then
      if ! awk --help 2>/dev/null >/dev/null; then
         if ! _busybox_has awk; then
            return 1
         fi
         g_avail_awk_busybox=true
      fi
      g_avail_awk=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_awk ] && return 0
   
   if [ $g_avail_awk_busybox ]; then
      busybox awk "$@"
   else
      awk "$@"
   fi
}

_busybox() {
   if ! [ $g_avail_busybox ]; then
      return 1
   fi
   g_avail_busybox=true
   
   [ "$1" = --available ] && [ $g_avail_busybox ] && return 0
   
   busybox "$@"
}

_grep() {
   if ! [ $g_avail_grep ]; then
      if ! grep --help 2>/dev/null >/dev/null; then
         if ! _busybox_has grep; then
            return 1
         fi
         g_avail_grep_busybox=true
      fi
      g_avail_grep=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_grep ] && return 0
   
   if [ $g_avail_grep_busybox ]; then
      busybox grep "$@"
   else
      grep "$@"
   fi
}

_gzip() {
   if ! [ $g_avail_gzip ]; then
      if ! gzip --help 2>/dev/null >/dev/null; then
         if ! _busybox_has gzip; then
            return 1
         fi
         g_avail_gzip_busybox=true
      fi
      g_avail_gzip=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_gzip ] && return 0
   
   if [ $g_avail_gzip_busybox ]; then
      busybox gzip "$@"
   else
      gzip "$@"
   fi
}

_sed() {
   if ! [ $g_avail_sed ]; then
      if ! sed --help 2>/dev/null >/dev/null; then
         if ! _busybox_has sed; then
            return 1
         fi
         g_avail_sed_busybox=true
      fi
      g_avail_sed=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_sed ] && return 0
   
   if [ $g_avail_sed_busybox ]; then
      busybox sed "$@"
   else
      sed "$@"
   fi
}

_tail() {
   if ! [ $g_avail_tail ]; then
      if ! tail --help 2>/dev/null >/dev/null; then
         if ! _busybox_has tail; then
            return 1
         fi
         g_avail_tail_busybox=true
      fi
      g_avail_tail=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_tail ] && return 0
   
   if [ $g_avail_tail_busybox ]; then
      busybox tail "$@"
   else
      tail "$@"
   fi
}

_tar() {
   if ! [ $g_avail_tar ]; then
      if ! tar --help 2>/dev/null >/dev/null; then
         if ! _busybox_has tar; then
            return 1
         fi
         g_avail_tar_busybox=true
      fi
      g_avail_tar=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_tar ] && return 0
   
   if [ $g_avail_tar_busybox ]; then
      busybox tar "$@"
   else
      tar "$@"
   fi
}

_md5() {
   if md5sum --help 2>/dev/null >/dev/null; then
      [ "$1" = --available ] && return 0 ||
         md5sum "$@" | awk '{print $1}'
   elif md5 --help 2>/dev/null >/dev/null; then
      [ "$1" = --available ] && return 0 ||
         md5 "$@" | awk '{print $1}'
   elif _busybox_has md5sum; then
      [ "$1" = --available ] && return 0 ||
         busybox md5sum "$@" | awk '{print $1}'
   elif openssl --help 2>/dev/null >/dev/null; then
      [ "$1" = --available ] && return 0 ||
         openssl md5 "$@" | awk '{print $2}'
   else
      return 1
   fi
}


_mkdir() {
   if ! [ $g_avail_mkdir ]; then
      if ! mkdir --help 2>/dev/null >/dev/null; then
         if ! _busybox_has mkdir; then
            return 1
         fi
         g_avail_mkdir_busybox=true
      fi
      g_avail_mkdir=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_mkdir ] && return 0
   
   if [ $g_avail_mkdir_busybox ]; then
      busybox mkdir "$@"
   else
      mkdir "$@"
   fi
}

_mktemp() {
   if ! [ $g_avail_mktemp ]; then
      if ! mktemp --help 2>/dev/null >/dev/null; then
         if ! _busybox_has mktemp; then
            return 1
         fi
         g_avail_mktemp_busybox=true
      fi
      g_avail_mktemp=true
   fi
   
   [ "$1" = --available ] && [ $g_avail_mktemp ] && return 0
   
   if [ $g_avail_mktemp_busybox ]; then
      busybox mktemp "$@"
   else
      mktemp "$@"
   fi
}

_missing_dependency() {
   echo "Missing script dependency '$1'"
   g_missing_dependency_error=true
}

# Verify script dependencies
_awk --available || _missing_dependency awk
_grep --available || _missing_dependency grep
_gzip --available || _missing_dependency gzip
_sed --available || _missing_dependency sed
_tail --available || _missing_dependency tail
_tar --available || _missing_dependency tar
_md5 --available || _missing_dependency md5/md5sum
_mkdir --available || _missing_dependency mkdir
_mktemp --available || _missing_dependency mktemp

if [ $g_missing_dependency_error]; then
   exit 1
fi

[ -d "$prefix" ] ||
   if ! _mkdir "$prefix" 2>/dev/null >/dev/null; then
      echo "ERROR: No write permission"
      exit 1
   fi

tmp=$(_mktemp $prefix/XXXXXX 2>/dev/null)
if [ $? -ne 0 ]; then
   echo "ERROR: No write permission"
   exit 1
fi
rm $tmp

echo "Self-Extracting Installer (http://codespunk.com)"

checksum=$(_awk '/^__MD5HASH__/ {print NR + 1; exit 0; }' "$0")
checksum=$(_sed "${checksum}q;d" "$0")

archive=$(_awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "$0")

echo -n "Verifying archive integrity..."

if ! [ "$(_tail -n+$archive "$0" | _md5)" = $checksum ]; then
   echo "ERROR"
   exit 1
fi

echo "OK"

echo "Decompressing data..."

_tail -n+$archive "$0" | \
if ! _tar xzv --exclude '\._*' -C "$prefix"; then
   echo "ERROR"
   exit 1
fi

echo "OK"

exit 0
EOF
)

function _package_make_e() {
   num=$#
   
   tmp_t=$(mktemp /tmp/_temp.t.XXXXXX)
   tmp_g=$(mktemp /tmp/_temp.g.XXXXXX)
   
   touch $tmp_t
   
   for i in "$@"; do
      tar -r -f $tmp_t "$i"
   done
   
   cat $tmp_t | gzip > $tmp_g
   
   echo "${__package_head}"
   
   echo "__MD5HASH__"
   cat $tmp_g | _md5
   
   echo "__ARCHIVE__"
   cat $tmp_g
   
   #cp $tmp_g a.tar.gz
   
   rm -f $tmp_t
   rm -f $tmp_g
}

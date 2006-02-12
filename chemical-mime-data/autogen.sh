#!/bin/sh
#
# Document  $Id$
# Summary   Auto-generate the package source.

## find where automake is installed and get the version
AMPATH=`which automake|sed 's/\/bin\/automake//'`
AMVER=`automake --version|grep automake|awk '{print $4}'|awk -F. '{print $1"."$2}'`

autogen_help() {
	echo
	echo "autogen.sh: Produces all files necessary to build the fglrx_man project files."
	echo "            The files are linked by default, if you run it without an option."
	echo
	echo "-c | --copy : Copy files instead to link them."
	echo "-h | --help : Print this message."
	echo
}

autogen_copy_if_missing() {
	if [ ! -e missing ] || [ ! -e mkinstalldirs ] || [ ! -e install-sh ] ; then
		echo "Manually copying automake scripts."
		cp -f $AMPATH/share/automake-$AMVER/missing .
		cp -f $AMPATH/share/automake-$AMVER/mkinstalldirs .
		cp -f $AMPATH/share/automake-$AMVER/install-sh .
	fi
}

autogen_copy() {
	intltoolize -f -c
	aclocal
	automake --gnu -a -c
	autogen_copy_if_missing
	autoconf
}

autogen_link_if_missing() {
	if [ ! -e missing ] || [ ! -e mkinstalldirs ] || [ ! -e install-sh ] ; then
		echo "Manually copying automake scripts."
		ln -sf $AMPATH/share/automake-$AMVER/missing .
		ln -sf $AMPATH/share/automake-$AMVER/mkinstalldirs .
		ln -sf $AMPATH/share/automake-$AMVER/install-sh .
	fi
}

autogen_link() {
	intltoolize -f
	aclocal
	automake --gnu -a
	autogen_link_if_missing
	autoconf
}


case "$1" in
	-h | --help)
		autogen_help
		exit 0
	;;
	-c | --copy)
		autogen_copy
	;;
	*)
		autogen_link
	;;
esac


## ready to rumble
echo "Run ./configure with the appropriate options, then make and enjoy."

exit 0


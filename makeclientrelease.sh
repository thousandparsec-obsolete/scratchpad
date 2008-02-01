#! /bin/sh

if [ -z $1 ]; then
	echo "No version!"
	exit
fi

WORKING=`pwd`/temp

if [ -d temp ]; then
	rm -rf temp
fi
if [ -d check ]; then
	sudo rm -rf check
fi
rm tpclient-pywx* 	2> /dev/null
rm libtpproto* 		2> /dev/null
rm libtpclient* 	2> /dev/null

if [ x"$1" = x"--clean" ]; then
	exit
fi

if [ x"$2" = x"" ]; then
	echo "No source location given"
	exit
fi

if [ -d $2 ]; then
	LOCAL=1
	URL=`pwd`/$2
else
	LOCAL=0
	URL=$2
fi
echo $URL


USELESS=".git .gitignore setup.nsi Makefile MANIFEST.in *.pyc *.spec tests STYLE doc/mac debian xrced"

mkdir temp

# tpclient-pywx (non-inplace)
##########################################################################
cd $WORKING

cg-clone $URL/tpclient-pywx || exit 1
cd tpclient-pywx
# Remove all the useless stuff
for FILE in $USELESS; do
	rm -rf `find . -wholename \*$FILE`
done

cd $WORKING
mv tpclient-pywx tpclient-pywx-$1
tar -jcvf ../tpclient-pywx-$1.tar.bz2 tpclient-pywx-$1

mv tpclient-pywx-$1 tpclient-pywx

# libtpproto-py
##########################################################################
cg-clone $URL/libtpproto-py || exit 1
cd libtpproto-py

rm -rf debian
mkdir libtpproto_py.egg-info
python setup.py sdist --formats=bztar  		> /dev/null
python setup.py bdist --formats=egg,rpm 	> /dev/null
rm -rf libtpproto_py.egg-info
rm ./dist/*.tar.gz ./dist/*.src.rpm
cp ./dist/* ../../

cd $WORKING

# libtpclient-py
##########################################################################
cg-clone $URL/libtpclient-py || exit 1
cd libtpclient-py

rm -rf debian
mkdir libtpclient_py.egg-info
python setup.py --ignore-deps sdist --formats=bztar 	> /dev/null
python setup.py --ignore-deps bdist --formats=egg 		> /dev/null
rm -rf libtpclient_py.egg-info
rm ./dist/*.tar.gz ./dist/*.src.rpm
cp ./dist/* ../../

cd $WORKING

# tpclient-pywx (inplace)
##########################################################################
cd tpclient-pywx
mkdir tp
cp -ar ../libtpclient-py/tp/* ./tp/
cp -ar ../libtpproto-py/tp/* ./tp/

for FILE in $USELESS; do
	rm -rf `find . -wholename \*$FILE`
done

cd $WORKING

mv tpclient-pywx tpclient-pywx-$1-inplace

tar -jcvf ../tpclient-pywx-$1-inplace.tar.bz2 tpclient-pywx-$1-inplace

# checking the output.. 
##########################################################################
echo "========================================================"
cd $WORKING/..
mkdir check
cd check
tar -jxvf ../libtpproto-py-*.tar.bz2
tar -jxvf ../libtpclient-py-*.tar.bz2
tar -jxvf ../tpclient-pywx-$1.tar.bz2
tar -jxvf ../tpclient-pywx-$1-inplace.tar.bz2

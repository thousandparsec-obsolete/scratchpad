#! /bin/sh

if [ -z $1 ]; then
	echo "No version!"
	exit
fi

if [ -d temp ]; then
	rm -rf temp
fi

mkdir temp
cd temp

darcs get --partial http://darcs.thousandparsec.net/repos/tpclient-pywx
cd tpclient-pywx
chmod a+x tpclient-pywx
darcs get --partial http://darcs.thousandparsec.net/repos/libtpclient-py tp
cd tp
darcs get --partial http://darcs.thousandparsec.net/repos/libtpproto-py netlib
cd ..
cd graphics
darcs get --partial http://darcs.thousandparsec.net/repos/media media
cd ..
cd ..

# Remove all the useless stuff
FILES="_darcs .boring setup.py setup.nsi Makefile MANIFEST.in *.pyc *.spec tests"
for FILE in $FILES; do
	rm -rf `find . -name $FILE`
done

mv tpclient-pywx tpclient-pywx-$1

tar -jcvf tpclient-pywx-$1.inplace.tar.bz2 tpclient-pywx-$1


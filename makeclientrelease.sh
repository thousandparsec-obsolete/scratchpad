#! /bin/sh

if [ -z $1 ]; then
	echo "No version!"
	exit
fi

if [ -d temp ]; then
	rm -rf temp
fi

USELESS="_darcs .boring setup.py setup.nsi Makefile MANIFEST.in *.pyc *.spec tests STYLE doc/mac"

mkdir temp
cd temp

darcs get --partial http://darcs.thousandparsec.net/repos/tpclient-pywx
cd tpclient-pywx
# Remove all the useless stuff
for FILE in $USELESS; do
	rm -rf `find . -name $FILE`
done
cd ..
tar -jcvf ../tpclient-pywx-$1.tar.bz2 tpclient-pywx

darcs get --partial http://darcs.thousandparsec.net/repos/libtpclient-py
cd libtpclient-py
python setup.py sdist --formats=bztar
python setup.py bdist --formats=egg,rpm
rm ./dist/*.tar.gz ./dist/*.src.rpm
cp ./dist/* ../../
cd ..

darcs get --partial http://darcs.thousandparsec.net/repos/libtpproto-py
cd libtpproto-py
python setup.py sdist --formats=bztar
python setup.py bdist --formats=egg,rpm
rm ./dist/*.tar.gz ./dist/*.src.rpm
cp ./dist/* ../../
cd ..

cd tpclient-pywx
chmod a+x tpclient-pywx
mkdir tp
cp -ar ../libtpclient-py/tp/* ./tp/
cp -ar ../libtpproto-py/tp/* ./tp/
cd ..
mv tpclient-pywx tpclient-pywx-$1

tar -jcvf ../tpclient-pywx-$1.inplace.tar.bz2 tpclient-pywx-$1
#rm -rf temp

#! /bin/sh

if [ ! -d tp ]; then
	mkdir tp
fi
cd tp

if [ -e netlib ]; then
	rm netlib
fi
ln -s ../libtpproto-py netlib

if [ -e client ]; then
	rm client
fi
ln -s ../libtpclient-py/client client

touch __init__.py

cd ..

if [ -e tpserver-py ]; then
	cd tpserver-py
	cd tp
	if [ ! -e netlib ]; then
		ln -s ../../libtpproto-py netlib
	fi
fi

if [ -e tpclient-pywx ]; then
	cd tpclient-pywx
	cd graphics
	if [ -e media ]; then 
		rm media
	fi
	ln -s ../../media media
fi

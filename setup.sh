#! /bin/sh

cd ..

# Setup the Darcs helper scripts
for FILE in `ls scratchpad/darcs-help/*.sh`; do
	SHORT=`basename $FILE`
	if [ ! -e $SHORT ]; then
		ln -s $FILE $SHORT
	fi
done

# Setup the links for inplace operation
if [ ! -d tp ]; then
	mkdir tp
	touch tp/__init__.py
fi

if [ -e libtpproto-py ]; then
	cd tp
	if [ -e netlib ]; then
		rm netlib
	fi
	ln -s ../libtpproto-py netlib
	cd ..
fi

if [ -e libtpclient-py ]; then
	cd tp
	if [ -e client ]; then
		rm client
	fi
	ln -s ../libtpclient-py/client client
	cd ..
fi

# Setup the Python Server for inplace operation
if [ -e tpserver-py ]; then
	cd tpserver-py
	chmod a+x tpserver-py tpserver-py-tool tpserver-py-turn

	cd tp
	if [ ! -e netlib ]; then
		ln -s ../../libtpproto-py netlib
	fi
	cd ..

	cd ..
fi

# Setup the tpclient-pywx for inplace operation
if [ -e tpclient-pywx ]; then
	cd tpclient-pywx

	chmod a+x tpclient-pywx

	if [ -e media ]; then 
		rm media
	fi
	ln -s ../media media
	cd ..
fi

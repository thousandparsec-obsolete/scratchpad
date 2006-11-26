#! /bin/sh

cd ..

# Setup the Darcs helper scripts
for FILE in `ls scratchpad/darcs-help/*.sh`; do
	SHORT=`basename $FILE`
	if [ ! -e $SHORT ]; then
		ln -s $FILE $SHORT
	fi
done

# Setup the Python Server for inplace operation
if [ -e tpserver-py ]; then
	cd tpserver-py
	chmod a+x tpserver-py tpserver-py-tool tpserver-py-turn

	cd tp
	if [ ! -e netlib ]; then
		ln -s ../../libtpproto-py/tp/netlib netlib
	fi
	cd ..

	cd ..
fi

# Setup the tpclient-pywx for inplace operation
if [ -e tpclient-pywx ]; then
	cd tpclient-pywx

	chmod a+x tpclient-pywx

	if [ ! -e tp ]; then
		mkdir tp
	fi
	cd tp
	if [ ! -e netlib ]; then
		if [ ! -e __init__.py ]; then
			ln -s ../../libtpproto-py/tp/__init__.py __init__.py
		fi
		ln -s ../../libtpproto-py/tp/netlib netlib
	fi
	if [ ! -e client ]; then
		ln -s ../../libtpclient-py/tp/client client
	fi
fi

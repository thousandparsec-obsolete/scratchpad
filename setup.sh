#! /bin/sh


cd ..

# Setup the Darcs helper scripts
for FILE in `ls scratchpad/git-helpers/*.sh`; do
	SHORT=`basename $FILE`
	if [ ! -e $SHORT ]; then
		ln -s $FILE $SHORT
	fi
done

if [ -e tp ]; then
	rm -rf tp
fi

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

	if [ -e tp ]; then
		rm -rf tp
	fi
	mkdir tp
	cd tp
	if [ ! -e __init__.py ]; then
		touch __init__.py
	fi
	if [ ! -e netlib ]; then
		ln -s ../../libtpproto-py/tp/netlib netlib
	fi
	if [ ! -e client ]; then
		ln -s ../../libtpclient-py/tp/client client
	fi
	cd ..

	cd ..
fi

if [ -e tpclient-pywx-dev ]; then
	echo "Setting up tpclient-pywx Development Branch"
	cd tpclient-pywx-dev

	chmod a+x tpclient-pywx

	if [ -e tp ]; then
		rm -rf tp
	fi
	mkdir tp
	cd tp
	if [ ! -e __init__.py ]; then
		touch __init__.py
	fi
	ln -fs ../../libtpproto-py/tp/netlib netlib
	ln -fs ../../libtpclient-py-dev/tp/client client
fi

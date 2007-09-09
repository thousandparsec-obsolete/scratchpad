#! /bin/sh


cd ..

# Setup the Darcs helper scripts
#for FILE in `ls scratchpad/git-helpers/*.sh`; do
#	SHORT=`basename $FILE`
#	if [ ! -e $SHORT ]; then
#		ln -s $FILE $SHORT
#	fi
#done

# FIXME: This is very dangerous!
#if [ -e tp ]; then
#	rm -rf tp
#fi

# Setup the Python Server for inplace operation
if [ -e tpserver-py ]; then
	echo "Setting up tpserver-py for inplace operation..."
	cd tpserver-py

	cd tp
	if [ ! -e netlib ]; then
		ln -s ../../libtpproto-py/tp/netlib netlib
	fi
	cd ..

	cd ..
fi

# Setup the tpclient-pywx for inplace operation
if [ -e tpclient-pywx ]; then
	echo "Setting up tpclient-pywx stable branch for inplace operation..."
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
	echo "Setting up tpclient-pywx development branch for inplace operation..."
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
	cd ..

	cd ..
fi


# Setup the tpsai-py for inplace operation
if [ -e tpsai-py ]; then
	echo "Setting up tpsai-py for inplace operation..."
	cd tpsai-py

	chmod a+x tpsai-py

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

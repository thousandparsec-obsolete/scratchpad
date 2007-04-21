#! /bin/sh

# Figure out the operating system

# Is this an apt-get based system like Ubuntu or Debian?
apt-get --version > /dev/null 2>&1; export RESULT=$?
if [ $RESULT -eq 0 ]; then
	# If this is ubuntu we need to run sudo, on Debian su is probably better
	RESULT=`lsb_release -a 2> /dev/null | grep Ubuntu | wc -l`
	if [ $RESULT -eq 0 ]; then
		# Going to assume it is a Debian system
		SUCMD="su root -c"
	elif [ $RESULT -eq 2 ]; then
		# Definately a Ubuntu system
		SUCMD="sudo"
	else
		SUCMD=""
	fi

	# Our first job is to find if darcs is installed
	RCS=cogito
	RESULT=`dpkg -l $RCS 2>&1`
	if [ "x$RESULT" = "xNo packages found matching $RCS." ]; then
		echo "I'm sorry but we can't continue until you install $RCS"
		echo "You can install darcs by running the following command:"
		echo "\t$SUCMD apt-get install $RCS"
		exit 1
	fi
elif [ $RESULT -eq 127 ]; then
	echo "Not an apt-get based system (ubuntu/debian)..."
	exit 1
else
	echo "Unknown return code! $RESULT"
	exit 1
fi

# Use Darcs to get scratchpad
echo "Getting scratchpad.."
if [ -e "scratchpad" ]; then
	echo "A directory called scratchpad already exists!"
	echo "Doing a pull in the directory instead.."
	cd scratchpad
	cg-update
	cd ..
else
	cg-clone http://git.thousandparsec.net/git/scratchpad.git
fi

# FIXME: Should check that this script is the newest version...
RESULT=`md5sum scratchpad/magicsetup.sh`

# Now we need to download all the stuff we need
REPOS="libtpproto-py libtpclient-py libtpclient-py-dev tpclient-pywx tpserver-py"
for repo in $REPOS; do
	if [ -e $repo ]; then
		echo "A directory called $repo already exists!"
		cd $repo
		cg-update
		cd ..
	else
		echo "Downloading the following repository $repo."
		cg-clone http://git.thousandparsec.net/git/$repo.git
	fi
done

cd scratchpad
sh setup.sh
cd ..
cd tpclient-pywx
python requirements.py


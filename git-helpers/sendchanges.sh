#! /bin/sh

DATE=`date +%Y%m%d-%H%M`

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/_darcs ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			darcs send http://darcs.thousandparsec.net/repos/$DIR -o ~/$DIR.patch.$DATE
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

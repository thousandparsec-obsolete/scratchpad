#! /bin/sh

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/_darcs ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			darcs push tim@darcs.thousandparsec.net:/var/lib/darcs/repos/$DIR
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

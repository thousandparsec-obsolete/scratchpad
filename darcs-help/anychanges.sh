#! /bin/sh

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/_darcs ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			darcs whatsnew -sl
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

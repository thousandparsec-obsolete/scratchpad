#! /bin/sh

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/.git ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			cg-fetch
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

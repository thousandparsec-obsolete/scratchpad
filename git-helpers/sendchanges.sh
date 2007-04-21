#! /bin/sh

DATE=`date +%Y%m%d-%H%M`

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/.git ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			git format-patch --keep-subject origin > ~/$DIR.patch.$DATE
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

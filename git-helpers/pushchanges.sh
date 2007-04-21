#! /bin/sh

for DIR in ls *; do
	if [ -d $DIR ]; then
		if [ -d $DIR/_darcs ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			if [ "x$TPUSER" == "x" ]; then
				TPUSER=$USER
			fi
			darcs push $TPUSER@darcs.thousandparsec.net:/var/lib/darcs/repos/$DIR
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

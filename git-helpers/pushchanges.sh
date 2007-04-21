#! /bin/sh

for DIR in `ls *`; do
	if [ -d $DIR ]; then
		if [ -d $DIR/.git ]; then
			echo
			echo $DIR
			echo "------------------------------------------"
			cd $DIR
			if [ "x$TPUSER" == "x" ]; then
				TPUSER=$USER
			fi
			# FIXME: This should push all branches...
			cg-branch-chg origin git+ssh://$TPUSER@git.thousandparsec.net/var/lib/git/$DIR.git
			cg-push
			cd ..
			echo "------------------------------------------"
		fi
	fi
done

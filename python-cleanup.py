#! /usr/bin/env python

# We are going to search all the directories listed in the path for the following things,
#  - libtp*.pth
#  - libtp*.egg
#  - tp
# Need to check for path in easy-install.pth
#
# We will list all the installed contents

import sys
import os

if __name__ == '__main__':
	toclean = set()

	print "# To use this run,"
	print "# > ./python-cleanup.py | sudo sh"

	for location in sys.path:
		if not os.path.exists(location):
			continue

		if location.endswith('tp'):
			toclean.add(location)
			continue

		if location.find('.egg') != -1:
			if location.find('libtp') != -1:
				toclean.add(location)
				continue

		if os.path.isdir(location):
			# Check for, .egg files
			# Check for, .pth
			# Check for, tp directory

			for file in os.listdir(location):
				if file.find('.egg') != -1 or file.endswith('.pth'):
					if file.startswith('libtp'):
						toclean.add(os.path.join(location, file))

				if file == 'tp':
					toclean.add(os.path.join(location, file))

				if file == 'easy-install.pth':
					for line in open(os.path.join(location, file)).xreadlines():
						if line.find('libtp') != -1:
							toclean.add(os.path.join(location, file))
							break

	tocleanu = set()
	while len(toclean) > 0:
		# Find the shortest element
		i = None
		for j in toclean:
			if i is None or len(j) < len(i):
				i = j
		toclean.remove(i)

		tocleanu.add(i)
		for j in set(toclean):
			if j.startswith(i):
				try:
					toclean.remove(j)
				except ValueError:
					continue


	for location in tocleanu:
		try: 
			if location.endswith('easy-install.pth'):
				print "# Rewrite easy-install.pth to remove the Thousand Parsec libraries."
				print "cat > %s <<EOF" % location
				for line in open(location, 'r').xreadlines():
					if line.find('libtp') != -1:
						continue
					print line[:-1]
				print "EOF"
				print

			while os.path.islink(location):
				# Figure out where this link goes too...
				print "rm %s" % location
				location = os.readlink(location)	
	
				# Check the destination of the link isn't already being removed.	
				for dir in tocleanu:
					if location.startswith(dir):
						raise IOError('testing')

			if os.path.isdir(location):
				print "rm -rf %s" % location
				print

			if os.path.isfile(location):
				print "rm %s" % location
				print

		except IOError:
			pass

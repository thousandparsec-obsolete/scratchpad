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
import os.path

# Modules names we create
modules = ['libtpproto', 'libtpclient' 'tpserver-py', 'tp', 'daneel']

if __name__ == '__main__':
	toclean = set()

	print "# To use this run,"
	print "# > ./python-cleanup.py | sudo sh"

	for location in sys.path:
		if not os.path.exists(location):
			continue

		if location.find('.egg') != -1:
			for module in modules:
				if location.find(module) != -1:
					toclean.add(location)
			continue

		if os.path.isdir(location):
			# Check for, .egg files
			# Check for, .pth
			# Check for, tp directory

			for file in os.listdir(location):
				if file.find('.egg') != -1 or file.endswith('.pth'):
					for module in modules:
						if file.startswith(module):
							toclean.add(os.path.join(location, file))

				for module in modules:
					if file == module:
						toclean.add(os.path.join(location, file))

				if file == 'easy-install.pth':
					for line in open(os.path.join(location, file)).xreadlines():
						for module in modules:
							if line.find(module) != -1:
								toclean.add(os.path.join(location, file))
								break
						else:
							continue

	# Check /usr/bin for scripts
	scripts = ["daneel-ai", "tpclient-pywx"]
	for script in scripts:
		for i in os.environ['PATH'].split(':'):
			s = os.path.join(i, script)
			if os.path.exists(s):
				toclean.add(s)

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
				continue

			while os.path.islink(location):
				# Figure out where this link goes too...
				print "# removing link"
				print "rm %s" % location
				location = os.readlink(location)	
	
				# Check the destination of the link isn't already being removed.	
				for dir in tocleanu:
					if location.startswith(dir):
						raise IOError('testing')

			if os.path.isdir(location):
				print "# removing dir"
				print "rm -rf %s" % location
				print

			if os.path.isfile(location):
				print "# removing file"
				print "rm %s" % location
				print

		except IOError:
			pass

	# Check for the tpclient-pywx stuff
	tpclientfiles = [ \
		"/usr/local/bin/tpclient-pywx", 
		"/usr/local/lib/tpclient-pywx", 
		"/usr/local/share/tpclient-pywx"
	]

	for bits in tpclientfiles:
		if os.path.exists(bits):
			print "rm -rf %s" % bits

	#if os.path.exists("/usr/local/lib/tpclient-pywx"):
	# /usr/local/share/locale/%s/LC_MESSAGES/
	# /usr/local/share/tpclient-pywx

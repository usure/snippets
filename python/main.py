#!/usr/bin/python
# Created by: TSF
#WTFPL
from sys import argv
import sys
selfname = sys.argv[0]
try:
   script, query = argv
except ValueError:
    print 'Syntax: %r "query"' % selfname
    quit()
#You will need this module: http://googolplex.sourceforge.net/
from google import search
for url in search('(%r)' % query, stop=20):
                print(url)





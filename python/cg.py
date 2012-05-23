#!/usr/bin/python
# Created by: TSF
#pip install google (REQUIREMENT)
from sys import argv
from google import search
import sys

selfname = sys.argv[0] # The name of the script itself.

try:
   script, query = argv
except ValueError:
    print 'Syntax: %r "query"' % selfname
    quit()
try:
    for url in search('(%r)' % query, stop=20):
   	       	print(url)
except KeyboardInterrupt:
 	quit()
 

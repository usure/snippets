#!/usr/bin/python
from sys import argv
script, query = argv
from google import search
for url in search('(%r)' % query, stop=20):
#for url in search('"',search, stop=3):
          print(url)

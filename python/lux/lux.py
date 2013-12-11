#!/usr/bin/python2
# If you are not using arch linux, then change the above line tu /usr/bin/python;
import SimpleHTTPServer
import SocketServer
import os

#def page(name):

def path(directory):
	os.chdir(directory)

def page(name,type,text):
	file = open(name + type, 'w+')
	file.write(text)
	print text

def rm_pages(type):
	os.system("rm *" + type)

def run(port):
        Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
        httpd = SocketServer.TCPServer(("", port), Handler)
        print "serving site at your ip:", port
	try:
	        httpd.serve_forever()
	except KeyboardInterrupt:
		print "Removing files"
		rm_pages(".html")
		quit()
		
#def run_server(port.host):
	
	

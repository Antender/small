include std/io.e
include std/map.e
include std/math.e
include std/text.e

object replace_map = load_map("trans1337er.map")
object output = {}
object buffer = {}
object text = {}

buffer=gets(STDIN)
while not(equal(buffer,EOF)) do
	text=text & buffer
	buffer=gets(STDIN)
end while

buffer={}
for i=1 to length(text) do
	buffer=get(replace_map,{upper(text[i])})
	if equal(buffer,0) then
		output=output & text[i]
	else
		output=output & buffer[mod(i,length(buffer))+1]
	end if
end for
puts(1,output)
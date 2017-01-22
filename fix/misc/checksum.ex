public function mod(object x, object y)
	return x - y * floor(x / y)
end function
sequence input=gets(0)
input=input[1..$-2]
integer count=0
for i=1 to length(input) do
	count+=input[i]
end for
?(count-256*floor(count/256))
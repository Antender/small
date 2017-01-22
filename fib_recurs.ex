include std/convert.e
function fib (integer n)
	switch n do
	case 0,1 then
		return n
	case else
		return fib(n-1)+fib(n-2)
	end switch
end function
sequence input=gets(0) 
print(1,fib(to_integer(input[1..$-2])))
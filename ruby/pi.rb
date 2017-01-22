def PI_ex(precision)
	flag=true
	result=4.0
	
	puts 1.0/precision
	for i in 1..precision do
		if flag==true
			result-=4.0/(1.0+2.0*i)
			flag = false
		else
			result+=4.0/(1.0+2.0*i)
			flag = true
		end
	end
	return result
end

puts PI_ex(8000000)
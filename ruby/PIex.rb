def PIex(precision)
	flag=true
	t=Time.now.to_r
	check=0
	for i in 1..1000000 do
		check+=4.0/(1.0+2.0*4.0)
	end
	t=Time.now.to_r-t
	result=4.0		
	for i in 1..precision do
		if flag==true
			result-=4.0/(1.0+2.0*i)
			flag=false
		else
			result+=4.0/(1.0+2.0*i)
			flag=true
		end
		if check>100000
			system 'cls'
			puts "Seconds to wait:#{(t*(precision-i)/1000000.0).to_i}"
			check=0
		end
		check+=1
	end
	return result
end
puts PIex(gets.to_i)
gets
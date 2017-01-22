class Array
	def random_uniq!(limit=9)
		self.fill(nil)
		self[0]=rand(limit-1)+1
		for i in 1..self.length-1 do
			while self[i]==nil do
				@@rand=rand(limit)
				self[i]=@@rand if !(self.include?(@@rand))
			end
		end
	end
	def random!(limit=9)
		self.collect! { |element| element=rand(limit) }
	end
	def random_uniq(num_elements,limit=9)
		temp_array.new 
		temp_array. do |index|
		return rand(limit-1)+1 if |index|==0
			while @@temp[i]==nil do
				@@rand=rand(limit)
				@@temp[i]=@@rand if !(@@temp.include?(@@rand))
			end
		end
	end
	def random(num_elements,limit=9)
		Array.new(num_elements) {rand(limit) }
	end
end
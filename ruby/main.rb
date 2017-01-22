load 'random_arrays.rb'

def help
puts <<HELP
After startup of program new number is already created
If you want to start new game type: new
To try some number: type this number
To view help: help
To view the number: surrender
To exit: exit    
HELP
end

def new_game(number,num_attempts)
  number.random_uniq!(9)
  num_attempts=0
  puts 'New number was created'
end

number=Array.new(4)
num_attempts=0

new_game(number,num_attempts)
loop do
  puts "Enter number,command (help, for example):"
  buffer=gets
  if buffer=="new\n"
   new_game(number,num_attempts)
  elsif buffer=="help\n"
   help
  elsif buffer=="surrender\n"
   puts "Old number was #{number}"
   new_game(number,num_attempts)
  elsif buffer=="exit\n"
   break
  elsif buffer.to_i.size==(buffer.length-1) then
   if number.size==(buffer.length-1) then
    bulls=0
    cows=0
    num_attempts=num_attempts+1
    for i in 0..number.length-1 do
    j=number.index(buffer[i].to_i)
    if j!=nil then
      if j==i then
        bulls=bulls+1
      elsif j!=i
        cows=cows+1
      end
    end
  end
  puts "Bulls:#{bulls} Cows:#{cows}"
  if bulls==4 then
    puts "WIN!!!!\nYou guessed number #{number.join} in #{num_attempts} attempts\n"
    new_game(number,num_attempts)
  end
   else
	  puts "Invalid number:#{buffer.to_i}"
	end
 end
end

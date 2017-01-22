load 'logics.rb'
require 'io/console'


deck = Deck.set
$player = Array.new(2) {Player.new(deck)}

def choose
	puts 'Choose a card:'
	input = '0' # check if nil is scary-shit
	until (1..4).include?(input.to_i) do
		input = STDIN.getch
	end
	return (input.to_i - 1)
end

def cout (player1 = $player[0], player2 = $player[1], drop = $drop)
	puts
	puts player2.to_s
	puts "#{player1.count}  [#{drop[0]}]   [#{drop[1]}]  #{player2.count}"
	puts player1.to_s
	puts
end
#offtopic: move return success
#"1", "2", "3", "4", " ".
def turn (player)
	cout

	while player.stalemate? do
		puts '!]![! STALEMATE !]![!'
		player.relief(Proc.new{choose})
		cout
		if player.empty? then
			puts '!]![! YOU WIN !]![!'
			exit
		end
	end

	input1 = STDIN.getch
	if input1 == "x" then exit end
	if input1 == "\s" then return end
	input2 = STDIN.getch
	
	if ((1..4).include?(input1.to_i)) && ((2..3).include?(input2.to_i)) then
		player.move((input1.to_i - 1), (input2.to_i - 2))
	end

	if player.empty? then
		puts '!]![! YOU WIN !]![!'
		exit
	end
end

loop do
	turn($player[0])
end
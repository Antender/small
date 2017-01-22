#1-13, 14-26, 27-39, 40-52
#0-12, 13-25, 26-38, 39-51
class Card
	@@Suits = ['a', 'b', 'c', 'd']
	@@Values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
	@@Variations = @@Suits.size * @@Values.size

	attr_reader :suit, :value, :index

	#arg is either a value or an index
	def initialize (arg = nil, suit = nil) #todo: *args

		if suit == nil && arg != nil then
			@index = arg
			@suit = (@index / @@Values.size).truncate
			@value = @index % @@Values.size # << I'm watching you... <<
		else
			if suit == nil then
				@suit = rand(@@Suits.size)
			else
				@suit = suit
			end

			if arg == nil then
				@value = rand(@@Values.size)
			else
				@value = value
			end
		end		
	end

	def to_s
		return @@Values[@value] + @@Suits[@suit]
	end

	def adj? (card)
		(card != nil) && (((card.value - @value).abs % 11) == 1)
	end

	def self.variations
		return @@Variations
	end
end

class Deck < Array
        @@deck = new(Card.variations) {|index| Card.new index}

	def self.set
		new(@@deck.shuffle)
	end

	def deal
		pop(Card.variations / 2)
	end
end

$drop = Array.new 2

class Player
	def initialize (deck)
		@stack = deck.deal
		@hand = Array.new(4) {@stack.pop}
	end

	def to_s
		@hand.reduce("") {|sum, card| sum + "[" + card.to_s + "] "}
	end

	def empty?
		@stack.empty? && (@hand == Array.new(4))
	end

	def can_move? (card, drop)
		($drop[drop] == nil) || $drop[drop].adj?(@hand[card])
	end

	def count
		@stack.size
	end

	def relief (func) # Determine player drops + AAAAAAA BYDLOKOD???????
		if @stack.empty? then
			while @hand[index = func.call] == nil do end
			$drop[1] = @hand[index]
			@hand[index] = nil
		else
			$drop[1] = @stack.pop
		end
	end

	def stalemate?
		acc = true

		for i in 0..(@hand.size - 1) do
			for j in 0..($drop.size - 1) do
				acc = acc && !can_move?(i, j)
			end
		end

		return acc
	end

	def move (card, drop)
		if can_move?(card, drop) then
			$drop[drop] = @hand[card]
			@hand[card] = @stack.pop
		end
	end
end

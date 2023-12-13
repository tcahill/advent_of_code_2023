class Hand
  CardOrder = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
    @type = cards.tally.values.sort.reverse
  end

  attr_reader :cards, :bid, :type

  def <=>(other)
    type_comparison = type <=> other.type

    return type_comparison if type_comparison != 0

    card_ranks = cards.map { |card| CardOrder.index(card) }
    other_card_ranks = other.cards.map { |card| CardOrder.index(card) }

    card_ranks <=> other_card_ranks
  end
end

input = File.read('../input')
hands = input.lines.map do |line|
  cards_string, bid_string = line.split
  Hand.new(cards_string.split(''), Integer(bid_string))
end

puts hands.sort.each_with_index.sum { |hand, i| hand.bid * (i + 1) }

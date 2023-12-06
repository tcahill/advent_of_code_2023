def id(card)
  card_id, _ = card.split(':')
  Integer(card_id.split[1])
end

def matches(card)
  _, numbers = card.split(':')
  winning_numbers, card_numbers = numbers.split('|')
  winning_numbers = winning_numbers.split.map { |i| Integer(i) }.to_set
  card_numbers.split.map { |i| Integer(i) }.reduce(0) do |matches, number|
    if winning_numbers.include?(number)
      matches + 1
    else
      matches
    end
  end
end

cards = File.read('../input').lines
matches =  cards.to_h { |card| [id(card), matches(card)] }
copies = cards.to_h { |card| [id(card), 1] }
max_id = matches.keys.max

matches.each do |id, num_matching|
  start_card = id + 1
  end_card = [id + num_matching + 1, max_id + 1].min
  (start_card...end_card).each do |i|
    copies[i] += copies[id]
  end
end

puts copies.values.sum

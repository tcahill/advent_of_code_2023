def score(card)
  card_id, numbers = card.split(':')
  winning_numbers, card_numbers = numbers.split('|')
  winning_numbers = winning_numbers.split.map { |i| Integer(i) }.to_set
  score = card_numbers.split.map { |i| Integer(i) }.reduce(nil) do |score, number|
    if winning_numbers.include?(number)
      if score.nil?
        score = 1
      else
        score = score * 2
      end
    end

    score
  end

  score || 0
end

cards = File.read('../input').lines
puts cards.sum { |card| score(card) || 0 }

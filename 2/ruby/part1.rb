MAX_QUANTITY = {
  'red' => 12,
  'green' => 13,
  'blue' => 14,
}

class Game
  def initialize(id, rounds)
    @id = id
    @rounds = rounds
  end

  attr_reader :id

  def possible?
    @rounds.all?(&:possible?)
  end

  def self.parse(string)
    game, rounds = string.split(':')
    id = Integer(game.split[1])
    rounds = rounds.split(';').map { |round| Round.parse(round) }
    new(id, rounds)
  end
end

class Round
  def initialize(counts)
    @counts = counts
  end

  def possible?
    @counts.all? { |color, quantity| quantity <= MAX_QUANTITY[color] }
  end

  def self.parse(string)
    counts = {}
    string.split(',').each do |count|
      quantity, color = count.split
      counts[color] = Integer(quantity)
    end

    new(counts)
  end
end

games = File.read('../input').lines.map { |line| Game.parse(line) }
puts games.select(&:possible?).sum(&:id)

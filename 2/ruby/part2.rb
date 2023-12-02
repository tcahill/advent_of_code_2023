class Game
  def initialize(id, rounds)
    @id = id
    @rounds = rounds
  end

  attr_reader :id

  def power
    minimum_counts.values.reduce(1) { |x, product| x * product }
  end

  def minimum_counts
    counts = {}
    counts.default = 0
    @rounds.each do |round|
      round.counts.each do |color, quantity|
        if quantity > counts[color]
          counts[color] = quantity
        end
      end
    end

    counts
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

  attr_reader :counts

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
puts games.sum(&:power)

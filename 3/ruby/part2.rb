gears = []
number_positions = []

current_number = nil

SchematicNumber = Struct.new(:number, :position) do
  def length
    number.to_s.length
  end
end

Gear = Struct.new(:ratio, :position) do
  def length
    1
  end
end

File.read('../input').lines.each.with_index do |line, line_index|
  number_positions << Array.new(line.length - 1, nil)
  line.each_char.with_index do |char, char_index|
    if char.ord >= '0'.ord && char.ord <= '9'.ord
      if current_number.nil?
        current_number = char
      else
        current_number += char
      end
    else
      unless current_number.nil?
        number = SchematicNumber.new(Integer(current_number), [line_index, char_index - current_number.length])
        (char_index - number.length..char_index - 1).each do |i|
          number_positions[line_index][i] = number
        end
        current_number = nil
      end

      if char == '*'
        gears << Gear.new(0, [line_index, char_index])
      end
    end
  end
end

def neighbor_positions(object)
  start_column = object.position[1]
  end_column = object.position[1] + object.length - 1

  neighbors = [[object.position[0], end_column + 1]]

  if start_column > 0
    neighbors << [object.position[0], start_column - 1]
  end

  ([start_column - 1, 0].max..end_column + 1).each do |i|
    neighbors << [object.position[0] - 1, i]
    neighbors << [object.position[0] + 1, i]
  end

  neighbors
end

gears.each do |gear|
  neighboring_numbers = neighbor_positions(gear).map do |neighbor|
    number_positions[neighbor[0]][neighbor[1]]&.number
  end.compact.uniq

  if neighboring_numbers.length == 2
    gear.ratio = neighboring_numbers[0] * neighboring_numbers[1]
  end
end

puts gears.sum(&:ratio)

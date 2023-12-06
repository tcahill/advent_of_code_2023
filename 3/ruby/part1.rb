numbers = []
symbol_positions = []

current_number = nil

SchematicNumber = Struct.new(:number, :position)

File.read('../input').lines.each.with_index do |line, line_index|
  symbol_positions << Array.new(line.length - 1, false)
  line.each_char.with_index do |char, char_index|
    if char.ord >= '0'.ord && char.ord <= '9'.ord
      if current_number.nil?
        current_number = char
      else
        current_number += char
      end
    else
      unless current_number.nil?
        numbers << SchematicNumber.new(Integer(current_number), [line_index, char_index - current_number.length])
        current_number = nil
      end

      unless ['.', "\n"].include?(char)
        symbol_positions.last[char_index] = true
      end
    end
  end
end

def neighbor_positions(number)
  start_column = number.position[1]
  end_column = number.position[1] + number.number.to_s.length - 1

  neighbors = [[number.position[0], end_column + 1]]

  if start_column > 0
    neighbors << [number.position[0], start_column - 1]
  end

  ([start_column - 1, 0].max..end_column + 1).each do |i|
    neighbors << [number.position[0] - 1, i]
    neighbors << [number.position[0] + 1, i]
  end

  neighbors
end

part_numbers = []

numbers.each do |number|
  neighbor_positions(number).each do |position|
    if symbol_positions[position[0]] && symbol_positions[position[0]][position[1]]
      part_numbers << number.number
      break
    end
  end
end

puts part_numbers.sum

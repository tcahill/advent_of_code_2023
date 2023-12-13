require 'debug'

CONNECTIONS = {
  '|' => [[-1, 0], [1, 0]],
  '-' => [[0, -1], [0, 1]],
  'L' => [[-1, 0], [0, 1]],
  'J' => [[-1, 0], [0, -1]],
  '7' => [[0, -1], [1, 0]],
  'F' => [[1, 0], [0, 1]],
}

def furthest_distance(rows)
  start = start_position(rows)
  current = start_neighbors(start, rows)
  visited = current.to_set
  visited << start

  i = 1
  loop do
    current = current.map { |node| connected(node, rows).reject { |c| visited.include?(c) }.first }.compact
    return i if current.empty?

    i += 1
    visited += current
  end
end

def connected(pipe, rows)
  connection_directions = CONNECTIONS[rows[pipe[0]][pipe[1]]]
  return [] if connection_directions.nil?

  connection_directions.map { |direction| [pipe, direction].transpose.map(&:sum) }
end

def start_position(rows)
  rows.each_with_index do |row, row_index|
    row.each_with_index do |column, column_index|
      if column == 'S'
        return [row_index, column_index]
      end
    end
  end
end

def adjacent(position)
  [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |direction|
    [position, direction].transpose.map(&:sum)
  end
end

def start_neighbors(start, rows)
  adjacent(start)
    .reject { |row, column| row.negative? || column.negative? || row >= rows.length || column >= rows.first.length }
    .select { |pipe| connected(pipe, rows).include?(start) }
end

input = File.read('../input')
puts furthest_distance(input.lines.map(&:chars))

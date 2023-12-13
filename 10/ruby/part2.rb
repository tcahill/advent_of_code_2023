require 'debug'

CONNECTIONS = {
  '|' => [[-1, 0], [1, 0]],
  '-' => [[0, -1], [0, 1]],
  'L' => [[-1, 0], [0, 1]],
  'J' => [[-1, 0], [0, -1]],
  '7' => [[0, -1], [1, 0]],
  'F' => [[1, 0], [0, 1]],
}

UPSCALED = {
  '|' => [
    ['*', '|', '*'],
    ['*', '|', '*'],
    ['*', '|', '*'],
  ],
  '-' => [
    ['*', '*', '*'],
    ['-', '-', '-'],
    ['*', '*', '*'],
  ],
  'L' => [
    ['*', '|', '*'],
    ['*', 'L', '-'],
    ['*', '*', '*'],
  ],
  'J' => [
    ['*', '|', '*'],
    ['-', 'J', '*'],
    ['*', '*', '*'],
  ],
  '7' => [
    ['*', '*', '*'],
    ['-', '7', '*'],
    ['*', '|', '*'],
  ],
  'F' => [
    ['*', '*', '*'],
    ['*', 'F', '-'],
    ['*', '|', '*'],
  ],
  '.' => [
    ['*', '*', '*'],
    ['*', '.', '*'],
    ['*', '*', '*'],
  ],
}

def enclosed_area(rows)
  original_start = set_start_value(rows)
  rows = upscale(rows)
  upscaled_start = original_start.map { |i| i * 3 + 1 }
  main_loop = main_loop(rows, upscaled_start).to_set
  tried = Set.new
  enclosed_positions = Set.new
  loop do
    start = nil
    rows.each_with_index do |row, row_index|
      row.each_with_index do |_column, column_index|
        if !main_loop.include?([row_index, column_index]) && !tried.include?([row_index, column_index])
          start = [row_index, column_index]
          break
        end
      end
      break unless start.nil?
    end

    enclosed_positions = bfs(start, main_loop, rows)
    unless enclosed_positions.any? { |pos| pos[0] == 0 || pos[0] == rows.length - 1 || pos[1] == 0 || pos[1] == rows.first.length - 1 }
      break
    end

    tried += enclosed_positions
  end

  enclosed_ground = enclosed_positions.select do |pos|
    value(pos, rows) == '.'
  end.length

  enclosed_pipes = enclosed_positions.select do |pos|
    !['*', '.'].include?(value(pos, rows))
  end.length / 3

  enclosed_ground + enclosed_pipes
end

def bfs(start, main_loop, rows)
  queue = [start]
  visited = Set.new
  until queue.empty?
    current = queue.shift
    visited << current
    queue += neighbors(current, visited, main_loop, rows)
    queue = queue.uniq
  end

  visited
end

def neighbors(position, main_loop, visited, rows)
  ns = []

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |direction|
    neighbor = [position, direction].transpose.map(&:sum)
    if !main_loop.include?(neighbor) && !visited.include?(neighbor) && neighbor.none?(&:negative?) && neighbor[0] < rows.length && neighbor[1] < rows.first.length
      ns << neighbor
    end
  end

  ns
end

def main_loop(rows, start)
  neighbors = connected(start, rows)
  current = neighbors.first
  positions = [start, current]
  loop do
    current = connected(current, rows).reject { |c| c == positions[-2] }.first
    break if current == start

    positions << current
  end

  positions
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

def set_start_value(rows)
  start = start_position(rows)
  neighbors = adjacent(start).select do |a|
    connected(a, rows).include?(start)
  end

  start_value = nil
  CONNECTIONS.each do |value, directions|
    ns = directions.map { |direction| [direction, start].transpose.map(&:sum) }
    if (neighbors & ns).length == 2
      start_value = value
    end
  end
  rows[start[0]][start[1]] = start_value

  start
end

def connected(pipe, rows)
  connection_directions = CONNECTIONS[rows[pipe[0]][pipe[1]]]
  return [] if connection_directions.nil?

  connection_directions.map { |direction| [pipe, direction].transpose.map(&:sum) }
end

def adjacent(position)
  [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |direction|
    [position, direction].transpose.map(&:sum)
  end
end

def value(position, rows)
  rows.dig(*position)
end

def upscale(rows)
  upscaled = Array.new(rows.length * 3) { Array.new(rows.first.length * 3) }
  rows.each_with_index do |row, row_index|
    row.each_with_index do |column, column_index|
      values = UPSCALED[column]
      (0..2).each do |row_offset|
        (0..2).each do |column_offset|
          upscaled[row_index*3 + row_offset][column_index*3 + column_offset] = values[row_offset][column_offset]
        end
      end
    end
  end
  upscaled
end

def start_neighbors(start, rows)
  adjacent(start)
    .reject { |row, column| row.negative? || column.negative? || row >= rows.length || column >= rows.first.length }
    .select { |pipe| connected(pipe, rows).include?(start) }
end

input = File.read('../input')

puts enclosed_area(input.lines.map(&:strip).map(&:chars))

require 'debug'

def find_cycle(steps, network, start_node)
  visited = Set.new
  visited_array = []

  current_node = start_node
  num_steps = 0
  index = 0
  while !(
    visited.include?(current_node) &&
      cycle?(steps, network, visited_array, current_node)
  )
    visited.add(current_node)
    visited_array << current_node
    direction = steps[num_steps % steps.length]

    if direction == 'L'
      current_node = network[current_node][0]
    else
      current_node = network[current_node][1]
    end

    num_steps += 1
    index = num_steps % steps.length
  end

  # position of cycle start, cycle length
  [visited_array.index(current_node), num_steps - visited_array.index(current_node)]
end

def cycle?(steps, network, visited, start_node)
  current_node = start_node
  cycle_length = visited.length - visited.index(start_node)
  start_step = visited.length
  (start_step..start_step + cycle_length - 1).each_with_index do |step, i|
    direction = steps[step % steps.length]

    if direction == 'L'
      current_node = network[current_node][0]
    else
      current_node = network[current_node][1]
    end

    if i == cycle_length - 1
      return current_node == start_node
    end

    return false if current_node != visited[visited.index(start_node) + i + 1]
  end

  false
end

input = File.read('../input')

steps, *network_lines = input.split("\n")
network = network_lines[1..].to_h do |line|
  match = /^([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)/.match(line)
  [match[1], match[2..]]
end

start_keys = network.keys.select { |key| key.end_with?('A') }
cycles = start_keys.map do |key|
  find_cycle(steps, network, key)
end
puts cycles.map { |c| c[1] }.reduce(1) { |acc, i| acc.lcm(i) }

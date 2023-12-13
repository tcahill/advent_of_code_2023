input = File.read('../input')

steps, *network_lines = input.split("\n")
network = network_lines[1..].to_h do |line|
  match = /^([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/.match(line)
  [match[1], match[2..]]
end

current_key = 'AAA'
num_steps = 0
while current_key != 'ZZZ'
  direction = steps[num_steps % steps.length]
  num_steps += 1

  if direction == 'L'
    current_key = network[current_key][0]
  else
    current_key = network[current_key][1]
  end
end

puts num_steps

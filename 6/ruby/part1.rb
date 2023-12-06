def ways_of_winning(input)
  times_line, distances_line = input.split("\n")
  _, *times = times_line.split
  _, *distances = distances_line.split

  times = times.map { |i| Integer(i) }
  distances = distances.map { |i| Integer(i) }

  ways = distances.each.zip(times).map do |distance, time|
    # 0 = -x^2 + t*x -d
    min_time = (((-time + Math.sqrt(time**2 - 4 * distance)) / -2) + 1).floor
    max_time = time - min_time
    (max_time - min_time) + 1
  end

  ways.reduce(1) { |product, w| product * w }
end

input = File.read('../input')
puts ways_of_winning(input)

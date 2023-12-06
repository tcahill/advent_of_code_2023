def ways_of_winning(input)
  times_line, distances_line = input.split("\n")
  _, *time_segments = times_line.split
  _, *distance_segments = distances_line.split
  time = Integer(time_segments.join)
  distance = Integer(distance_segments.join)

  min_time = (((-time + Math.sqrt(time**2 - 4 * distance)) / -2) + 1).floor
  max_time = time - min_time
  (max_time - min_time) + 1
end

input = File.read('../input')
puts ways_of_winning(input)

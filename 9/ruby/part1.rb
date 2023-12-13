def value(line)
  numbers = []
  numbers << line.split.map(&:to_i)

  while !numbers.last.all?(&:zero?)
    numbers << numbers.last.each_cons(2).map { |x, y| y - x }
  end

  numbers.reverse[1..].reduce(0) do |extrapolated, row|
    row.last + extrapolated
  end
end

input = File.read('../input')
puts input.lines.sum { |line| value(line) }

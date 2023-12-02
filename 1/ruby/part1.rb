def calibration_sum(document)
  document.lines.sum do |line|
    Integer(first_digit(line) + first_digit(line.reverse))
  end
end

def first_digit(line)
  line.each_char do |char|
    if char.ord >= '0'.ord && char.ord <= '9'.ord
      return char
    end
  end
end

document = File.read('../input')
puts calibration_sum(document)

# frozen_string_literal: true

WORD_TO_DIGIT = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
  'zero' => '0',
}.freeze

REVERSE_WORD_TO_DIGIT = WORD_TO_DIGIT.to_h { |k, v| [k.reverse, v] }

def calibration_sum(document)
  document.lines.sum { |line| Integer(first_digit(line) + last_digit(line)) }
end

def first_digit(line)
  alphabetic_substring = ''
  line.each_char do |char|
    return char if char.ord >= '0'.ord && char.ord <= '9'.ord

    alphabetic_substring += char
    WORD_TO_DIGIT.each do |number_word, digit|
      return digit if alphabetic_substring.end_with?(number_word)
    end
  end
end

def last_digit(line)
  alphabetic_substring = ''
  line.reverse.each_char do |char|
    return char if char.ord >= '0'.ord && char.ord <= '9'.ord

    alphabetic_substring += char
    REVERSE_WORD_TO_DIGIT.each do |number_word, digit|
      return digit if alphabetic_substring.end_with?(number_word)
    end
  end
end

document = File.read('../input')
puts calibration_sum(document)

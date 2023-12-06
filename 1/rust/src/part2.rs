use std::fs::File;
use std::io::{self, BufRead};
use std::iter::Iterator;

const WORD_TO_DIGIT: [(&str, u32); 10] = [
    ("one", 1),
    ("two", 2),
    ("three", 3),
    ("four", 4),
    ("five", 5),
    ("six", 6),
    ("seven", 7),
    ("eight", 8),
    ("nine", 9),
    ("zero", 0),
];

const REVERSE_WORD_TO_DIGIT: [(&str, u32); 10] = [
    ("eno", 1),
    ("owt", 2),
    ("eerht", 3),
    ("ruof", 4),
    ("evif", 5),
    ("xis", 6),
    ("neves", 7),
    ("thgie", 8),
    ("enin", 9),
    ("orez", 0),
];

pub fn run() {
    let input_file = File::open("../input").unwrap();
    let lines = io::BufReader::new(input_file);
    let sum: u32 = lines.lines()
        .filter_map( |line| Some(line_value(line.ok()?)) )
        .map( |v| v.unwrap() )
        .sum();
    println!("{}", sum)
}

fn line_value(line: String) -> Option<u32> {
    Some(10 * first_digit(&line)? + last_digit(&line)?)
}

fn first_digit(line: &str) -> Option<u32> {
    let mut alphabetic_substring = String::from("");
    for c in line.chars() {
        if c.is_ascii_digit() {
            return c.to_digit(10)
        }

        alphabetic_substring.push(c);
        for (word, digit) in WORD_TO_DIGIT {
            if alphabetic_substring.ends_with(word) {
                return Some(digit)
            }
        }
    }

    None
}

fn last_digit(line: &str) -> Option<u32> {
    let mut alphabetic_substring = String::from("");
    for c in line.chars().rev() {
        if c.is_ascii_digit() {
            return c.to_digit(10)
        }

        alphabetic_substring.push(c);
        for (word, digit) in REVERSE_WORD_TO_DIGIT {
            if alphabetic_substring.ends_with(word) {
                return Some(digit)
            }
        }
    }

    None
}

use std::fs::File;
use std::io::{self, BufRead};
use std::iter::Iterator;

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
    let first_digit = line.chars().find(|c| c.is_ascii_digit())?.to_digit(10)?;
    let last_digit = line.chars().rev().find(|c| c.is_ascii_digit())?.to_digit(10)?;
    Some(10 * first_digit + last_digit)
}

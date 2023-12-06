MyRange = Struct.new(:from, :to) do
  def intersection(other)
    MyRange.new([other.from, from].max, [other.to, to].min)
  end
end

def parse_seeds(input)
  seeds_string, *map_strings = input.split(/\n{2}/)
  seeds = seeds_string.split[1..]
    .each_slice(2)
    .map { |range| range.map { |i| Integer(i) } }
    .map { |range| MyRange.new(range[0], range[0] + range[1] - 1) }

  maps = map_strings.map { |s| parse_map(s) }

  [seeds, maps]
end

Map = Struct.new(:source, :destination, :ranges) do
  def get_ranges(index_range)
    out_ranges = []
    current_range = index_range

    sorted_ranges = ranges.sort_by { |range| range.first.from }
    sorted_ranges.each do |source_range, destination_range|
      source_intersection = source_range.intersection(current_range)

      destination_intersection = MyRange.new(
        destination_range.from + (source_intersection.from - source_range.from),
        destination_range.to - (source_range.to - source_intersection.to),
      )

      destination_left = MyRange.new(
        current_range.from,
        [current_range.to, source_range.from - 1].min
      )

      current_range = MyRange.new([current_range.from, source_range.to + 1].max, current_range.to)

      out_ranges += [destination_intersection, destination_left]
    end

    if index_range.to > sorted_ranges.last.first.to
      out_ranges += [MyRange.new(
        [sorted_ranges.last.first.to + 1, index_range.from].max,
        index_range.to,
      )]
    end

    if index_range.from < sorted_ranges.first.first.from
      out_ranges += [MyRange.new(
        index_range.from,
        [sorted_ranges.first.first.from - 1, index_range.to].min,
      )]
    end

    out_ranges.select { |range| range.to - range.from >= 0 }
  end
end

def parse_map(input)
  header, *mappings = input.split("\n")
  source, _to, destination = header.split.first.split('-')

  ranges = mappings.map do |mapping|
    destination_start, source_start, range = mapping.split.map{ |i| Integer(i) }
    [MyRange.new(source_start, source_start + range - 1), MyRange.new(destination_start, destination_start + range - 1)]
  end

  Map.new(source, destination, ranges)
end

def locations(input)
  seeds, maps = parse_seeds(input)
  maps = maps.to_h { |m| [m.source, m] }

  seeds.map do |seed|
    current_source = 'seed'
    current_ranges = [seed]
    while current_source != 'location'
      map = maps[current_source]
      current_ranges = current_ranges.map do |range|
        map.get_ranges(range)
      end.flatten
      current_source = map.destination
    end
    current_ranges
  end.flatten
end

input = File.read('../input')
puts locations(input).min_by { |r| r.from }.from

def parse_seeds(input)
  seeds_string, *map_strings = input.split(/\n{2}/)
  seeds = seeds_string.split[1..].map { |s| Integer(s) }

  maps = map_strings.map { |s| parse_map(s) }

  [seeds, maps]
end

Map = Struct.new(:source, :destination, :ranges) do
  def get(x)
    ranges.each do |range|
      if x <= range[1] && x >= range[0]
        return range[2] + (x - range[0])
      end
    end

    return x
  end
end

def parse_map(input)
  header, *mappings = input.split("\n")
  source, _to, destination = header.split.first.split('-')

  ranges = mappings.map do |mapping|
    destination_start, source_start, range = mapping.split.map{ |i| Integer(i) }
    [source_start, source_start + range - 1, destination_start]
  end

  Map.new(source, destination, ranges)
end

def locations(input)
  seeds, maps = parse_seeds(input)
  maps = maps.to_h { |m| [m.source, m] }

  seeds.map do |seed|
    current_source = 'seed'
    value = seed
    while current_source != 'location'
      map = maps[current_source]
      value = map.get(value)
      current_source = map.destination
    end
    value
  end
end

input = File.read('../input')
puts locations(input).min

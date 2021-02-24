require "pry"

COORDINATES = File.read(File.expand_path("input.txt"))
  .split("\n")
  .map { _1.split(/(\d+)/) }
  .map { [_1[0], _1[1].to_i] }

class Move
  DIRECTIONS = %w[N E S W]

  def initialize(direction, x, y)
    @direction = direction
    @coords = {x: x, y: y}
  end

  attr_reader :direction, :coords

  def right(degrees)
    @direction = DIRECTIONS[(DIRECTIONS.index(direction) + degrees / 90) % 4]
  end

  def left(degrees)
    @direction = DIRECTIONS[(DIRECTIONS.index(direction) - degrees / 90) % 4]
  end

  def forward(point)
    case direction
    when "N"
      coords[:y] += point
    when "E"
      coords[:x] += point
    when "S"
      coords[:y] -= point
    when "W"
      coords[:x] -= point
    end
  end
end

DIRECTIONS_MAPPER = {
  "N" => ->(move, point) { move.coords[:y] += point },
  "S" => ->(move, point) { move.coords[:y] -= point },
  "E" => ->(move, point) { move.coords[:x] += point },
  "W" => ->(move, point) { move.coords[:x] -= point },
  "L" => ->(move, degrees) { move.left(degrees) },
  "R" => ->(move, degrees) { move.right(degrees) },
  "F" => ->(move, point) { move.forward(point) }
}

def calculate_puzzle1
  move = Move.new("E", 0, 0)

  COORDINATES.each do |coordinate|
    DIRECTIONS_MAPPER.fetch(coordinate[0]).call(move, coordinate[1])
  end

  move.coords.values.sum(&:abs)
end

puzzle1 = calculate_puzzle1

# --- Part Two ---

class SectorDetector
  SECTORS = [
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ].freeze

  def initialize(x, y)
    @x = x
    @y = y
    @sector = SECTORS[sector_position]
  end

  def right(degrees)
    next_position = (sector_position + degrees / 90) % 4
    move(next_position)
  end

  def left(degrees)
    next_position = (sector_position - degrees / 90) % 4
    move(next_position)
  end

  private

  attr_reader :x, :y, :sector

  def sector_position
    SECTORS.each_with_index do |(sec_x, sec_y), index|
      return index if (x.positive? == sec_x.positive?) && (y.positive? == sec_y.positive?)
    end
  end

  def move(next_position)
    moved_to_sector = ((sector_position.abs - next_position.abs) % 2).odd? ? [y, x] : [x, y]
    sec_x, sec_y = SECTORS[next_position]
    new_x = sec_x.positive? ?  moved_to_sector[0].abs : -(moved_to_sector[0].abs)
    new_y = sec_y.positive? ?  moved_to_sector[1].abs : -(moved_to_sector[1].abs)
    [new_x, new_y]
  end
end

class Move2
  DIRECTIONS = %w[N E S W]


  def initialize(x, y, waypoints:)
    @coords = {x: x, y: y}
    @waypoints = waypoints
  end

  attr_reader :coords, :waypoints

  def right(degrees)
    x, y = SectorDetector.new(waypoints[:x], waypoints[:y]).right(degrees)
    @waypoints = { x: x, y: y }
  end

  def left(degrees)
    x, y = SectorDetector.new(waypoints[:x], waypoints[:y]).left(degrees)
    @waypoints = { x: x, y: y }
  end

  def forward(point)
    coords[:x] += waypoints[:x] * point
    coords[:y] += waypoints[:y] * point
  end
end

DIRECTIONS_MAPPER_2 = {
  "N" => ->(move, point) { move.waypoints[:y] += point },
  "S" => ->(move, point) { move.waypoints[:y] -= point },
  "E" => ->(move, point) { move.waypoints[:x] += point },
  "W" => ->(move, point) { move.waypoints[:x] -= point },
  "L" => ->(move, degrees) { move.left(degrees) },
  "R" => ->(move, degrees) { move.right(degrees) },
  "F" => ->(move, point) { move.forward(point) }
}

def calculate_puzzle2
  move = Move2.new(0, 0, waypoints: {x: 10, y: 1})

  COORDINATES.each do |coordinate|

    DIRECTIONS_MAPPER_2.fetch(coordinate[0]).call(move, coordinate[1])
  end

  move.coords.values.sum(&:abs)
end

puzzle2 = calculate_puzzle2
puts [puzzle1, puzzle2]

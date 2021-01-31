require "pry"

COORDINATES = File.read(File.expand_path("input.txt"))
  .split("\n")
  .map { _1.split(/(\d+)/) }
  .map { [_1[0], _1[1].to_i] }

BAS_COORDINATES = {x: 0, y: 0}

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

move = Move.new("E", 0, 0)

COORDINATES.each do |coordinate|
  DIRECTIONS_MAPPER.fetch(coordinate[0]).call(move, coordinate[1])
end

def calculate_puzzle1
  move = Move.new("E", 0, 0)

  COORDINATES.each do |coordinate|
    DIRECTIONS_MAPPER.fetch(coordinate[0]).call(move, coordinate[1])
  end

  move.coords.values.sum(&:abs)
end

puzzle1 = calculate_puzzle1

puts [puzzle1]

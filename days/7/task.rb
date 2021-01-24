require "pry"

base_data = File.read(File.expand_path("input.txt"))
  .split("\n")
  .map { _1.split(" contain ") }
  .map { [_1.gsub(/ bags/, ""), _2.split(/[,.]\s?/)] }
  .map { [_1, _2.map { |val| val.gsub(/ bags?/, "") }] }
  .map { [_1, _2 == ["no other"] ? [] : _2] }
  .map { [_1, _2.map { |val| val.split(" ", 2) }] }
  .map { [_1, _2.map { |count, color| [count.to_i, color] }] }

Description = Struct.new(:name, :count)

class Node
  def initialize(name)
    @name = name
    @descriptions = []
  end

  attr_reader :name, :descriptions

  def add(name, count)
    descriptions << Description.new(name, count)
  end
end

def populate(base_data)
  acc = {}

  base_data.each do |color_name, descriptions|
    acc[color_name] ||= Node.new(color_name)

    descriptions.each do |count, desc_color_name|
      acc[desc_color_name] ||= Node.new(desc_color_name)
      acc[color_name].add(desc_color_name, count)
    end
  end

  acc
end

COLOR_MAPPING = populate(base_data)
SUITABLE_COLOR = "shiny gold"

def contain_color?(color)
  node = COLOR_MAPPING[color]
  return true if node.name == SUITABLE_COLOR
  node.descriptions.any? { |description| contain_color?(description.name) }
end

def calc_bags_for_color(color, counter = 0)
  node = COLOR_MAPPING[color]

  return 0 if node.descriptions.empty?

  inside = node.descriptions.sum { |description| description.count * calc_bags_for_color(description.name) }
  itself = node.descriptions.sum(&:count)

  [counter, inside, itself].sum
end

puzzle1 = COLOR_MAPPING.values.count { |node| node.descriptions.any? { |desc| contain_color?(desc.name) } }
puzzle2 = calc_bags_for_color(SUITABLE_COLOR)

puts [puzzle1, puzzle2]

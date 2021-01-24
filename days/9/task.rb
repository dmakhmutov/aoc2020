require "pry"

DATA = File.read(File.expand_path("input.txt")).split("\n").map(&:to_i)

def sum_exists(list, sum, combination_number)
  Array(list).combination(combination_number).find_all { |x, y| x + y == sum } || []
end

def find_weakness(preamble:)
  DATA[preamble..].each.with_index do |number, index|
    window = DATA[index..preamble + index - 1]
    adders = sum_exists(window, number, 2)

    break number if adders.empty?
  end
end

weak_number = find_weakness(preamble: 25)

class Window
  def initialize(start, stop)
    @start = start
    @stop = stop
  end

  attr_accessor :start, :stop
end

def find_contiguous_set(weak_number, available_list, window = Window.new(0, 4))
  list = available_list[window.start..window.stop]
  return list if list.sum == weak_number

  window.stop += 1 if list.sum < weak_number
  window.start += 1 if list.sum > weak_number

  find_contiguous_set(weak_number, available_list, window)
end

weak_index = DATA.index(weak_number)
available_list = DATA[..weak_index - 1]

set = find_contiguous_set(weak_number, available_list)
puzzle1 = weak_number
puzzle2 = set.min + set.max

p [puzzle1, puzzle2]

require "pry"

SEQUENCE = [16,11,15,0,1,7]

class Counter
  attr_accessor :count, :positions

  def initialize(count, position)
    @count = count
    @positions = Array(position)
  end

  def inc(position)
    @count += 1
    @positions << position
    self
  end

  def position_diff
    (@positions[-2] - @positions[-1]).abs
  end
end


def run(limit: 10, numbers: SEQUENCE)
  limit.times do
    counter = MEMO[numbers.last]

    if counter
      if counter.count == 1
        numbers.push(0)
        MEMO[0] = MEMO[0] ? MEMO[0].inc(numbers.count - 1) : Counter.new(1, numbers.count - 1)
      else
        new_value = counter.position_diff
        numbers.push(new_value)
        MEMO[new_value] = MEMO[new_value] ? MEMO[new_value].inc(numbers.count - 1) : Counter.new(1, numbers.count - 1)
      end
    else
      numbers.push(0)
      MEMO[0] = MEMO[0].inc(numbers.count - 1)
    end
  end
  numbers
end

def prepare
  SEQUENCE.each_with_index { |num, index| MEMO[num] = Counter.new(1, index) }
end

MEMO = Hash.new(false)
prepare
puzzle1 = run(limit: 2020)[2020 - 1]

MEMO = Hash.new(false)
prepare
puzzle2 = run(limit: 30000000)[30000000 - 1]


p [puzzle1, puzzle2]

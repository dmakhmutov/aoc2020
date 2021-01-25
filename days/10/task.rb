require "pry"

ADAPTERS = File.read(File.expand_path("input.txt")).split("\n").map(&:to_i).sort

def calculate_jolt_difference(acc: Hash.new(0), max_jolt: ADAPTERS.max + 3)
  ADAPTERS.each.with_index(1) do |number, next_idx|
    acc[number] += 1 if next_idx == 1
    next_number = ADAPTERS[next_idx] || max_jolt
    acc[next_number - number] += 1
  end
  acc.values.reduce(:*)
end

puzzle1 = calculate_jolt_difference

ADAPTERS.unshift 0
ADAPTERS.push ADAPTERS.last + 3
MEMO = {}

def search(idx, adapters)
  return MEMO[idx] if MEMO[idx]
  return 1 if idx == adapters.length - 1

  start = adapters[idx]

  next_idx = idx + 1
  children = []

  while true
    break if adapters[next_idx].nil?
    if adapters[next_idx] - start <= 3
      children << next_idx
    else
      break
    end
    next_idx += 1
  end

  MEMO[idx] = children.sum { |child| search(child, adapters) }
end

puzzle2 = search(0, ADAPTERS)

p [puzzle1, puzzle2]

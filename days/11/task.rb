require "pry"
SEATS = File.read(File.expand_path("input.txt")).split("\n")
CHECKING_STEPS = [
  [-1, -1],
  [-1, 0],
  [1, -1],
  [1, 0],
  [1, 1],
  [0, 1],
  [-1, 1],
  [0, -1]
]

def can_be_occupied?(seats, x:, y:)
  return false if seats[x][y] == "."

  CHECKING_STEPS.all? do |xi, yi|
    next true if x + xi < 0 || x + xi > seats.size - 1
    next true if y + yi < 0 || y + yi > seats[y].size - 1

    seats[x +xi][y + yi] == "L" || seats[x +xi][y + yi] == "."
  end
end

def can_be_empty?(seats, x:, y:)
  occupied_counter = 0

  return false if seats[x][y] == "."

  CHECKING_STEPS.each do |xi, yi|
    next if x + xi < 0 || x + xi > seats.size - 1
    next if y + yi < 0 || y + yi > seats[x].size - 1

    occupied_counter += 1 if seats[x + xi][y + yi] == "#"
  end

  occupied_counter >= 4
end

def run(prev_seats:)
  seats = []
  return prev_seats if MEMO_STEPS[prev_seats]

  MEMO_STEPS[prev_seats] ||= 1

  prev_seats.each.with_index(0) do |seat_row, x_idx|
    seats << seat_row.dup
    seat_row.split("").each.with_index(0) do |prev_value, y_idx|
      seats[x_idx][y_idx] = "#" if can_be_occupied?(prev_seats, x: x_idx, y: y_idx) && prev_value == "L"
      seats[x_idx][y_idx] = "L" if can_be_empty?(prev_seats, x: x_idx, y: y_idx) && prev_value == "#"
    end
  end

  run(prev_seats: seats)
end

MEMO_STEPS = {}
last_operation = run(prev_seats: SEATS)
puzzle1 = last_operation.sum { _1.split("").sum { |a| a == "#" ? 1 : 0 } }

########################################################################################

def can_empty?(seats, x, y, xi, yi)
  return false if x + xi < 0 || x + xi > seats.size - 1
  return false if y + yi < 0 || y + yi > seats[x].size - 1
  return false if seats[x + xi][y + yi] == "L"

   seats[x + xi][y + yi] == "#" ? true : can_empty?(seats, x + xi, y + yi, xi, yi)
end

def can_be_empty_2?(seats, x:, y:)
  occupied_counter = 0

  return false if seats[x][y] == "."

  CHECKING_STEPS.each do |xi, yi|
    occupied_counter += 1 if can_empty?(seats, x, y, xi, yi)
  end

  occupied_counter >= 5
end

def occupied?(seats, x, y, xi, yi)
  return true if x + xi < 0 || x + xi > seats.size - 1
  return true if y + yi < 0 || y + yi > seats[y].size - 1

  return true if seats[x +xi][y + yi] == "L"
  return false if seats[x +xi][y + yi] == "#"
  occupied?(seats, x + xi, y + yi, xi, yi) if seats[x +xi][y + yi] == "."
end

def can_be_occupied_2?(seats, x:, y:)
  return false if seats[x][y] == "."

  CHECKING_STEPS.all? { |xi, yi| occupied?(seats, x, y, xi, yi) }
end

def run_2(prev_seats:)
  seats = []
  return prev_seats if MEMO_STEPS[prev_seats]

  MEMO_STEPS[prev_seats] ||= 1

  prev_seats.each.with_index(0) do |seat_row, x_idx|
    seats << seat_row.dup
    seat_row.split("").each.with_index(0) do |prev_value, y_idx|
      seats[x_idx][y_idx] = "#" if can_be_occupied_2?(prev_seats, x: x_idx, y: y_idx) && prev_value == "L"
      seats[x_idx][y_idx] = "L" if can_be_empty_2?(prev_seats, x: x_idx, y: y_idx) && prev_value == "#"
    end
  end

  run_2(prev_seats: seats)
end

MEMO_STEPS = {}
last_operation = run_2(prev_seats: SEATS)
puzzle2 = last_operation.sum { _1.split("").sum { |a| a == "#" ? 1 : 0 } }

p [puzzle1, puzzle2]

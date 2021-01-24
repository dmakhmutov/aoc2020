require "pry"

MULTIPLE_INSTRUCTIONS = []
INSTRUCTIONS = File.read(File.expand_path("input.txt"))
  .split("\n")
  .map { _1.split(" ") }
  .map { [_1, _2.to_i] }

def puzzle_run(instructions:, instruction_position: 0, steps_done: {}, acc: 0)
  command, num = instructions[instruction_position]

  return [acc, "End of cycle"] if command.nil?
  return [acc, "Before exec second time"] if steps_done[instruction_position] == true
  steps_done[instruction_position] = true

  case command
  when "nop"
    puzzle_run(instruction_position: instruction_position + 1, acc: acc, steps_done: steps_done, instructions: instructions)
  when "acc"
    acc += num
    puzzle_run(instruction_position: instruction_position + 1, acc: acc, steps_done: steps_done, instructions: instructions)
  when "jmp"
    puzzle_run(instruction_position: instruction_position + num, acc: acc, steps_done: steps_done, instructions: instructions)
  end
end

def generate_combinations
  INSTRUCTIONS.each.with_index do |(command, num), index|
    new_command =
      case command
      when "nop"
        "jmp"
      when "jmp"
        "nop"
      when "acc"
        "acc"
      end

    if new_command != command
      new_instructions = INSTRUCTIONS.dup
      new_instructions[index] = [new_command, num]
      MULTIPLE_INSTRUCTIONS << new_instructions
    end
  end
end

def find_end_of_cycle
  generate_combinations

  MULTIPLE_INSTRUCTIONS.each do |instructions|
    acc, message = puzzle_run(instructions: instructions)
    break acc if message == "End of cycle"
  end
end

puzzle1, _ = puzzle_run(instructions: INSTRUCTIONS)
puzzle2 = find_end_of_cycle

p [puzzle1, puzzle2]

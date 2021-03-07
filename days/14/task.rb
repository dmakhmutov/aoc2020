require "pry"

INSTRUCTIONS = File.read(File.expand_path("input.txt")).split("\n").map { |line| line.chomp.split(' = ') }

def run(version = 1)
  mask = { raw: '', off: 0, on: 0, addr: '', floating_indexes: [] }
  mem = {}

  INSTRUCTIONS.each do |instr|
    case instr[0]
    when /mem/
      addr = instr[0][4..-2].to_i
      val = instr[1].to_i

      case version
      when 1
        mem[addr] = (val | mask[:on]) & ~mask[:off]
      when 2
        addr_full = addr.to_s(2).rjust(mask[:raw].size, '0').reverse
        mask[:addr] = mask[:raw]
                      .chars.each_with_index
                      .map { |b, i| b == '0' ? addr_full[i] : mask[:raw][i] }
                      .join
        mask[:floating_indexes] = mask[:addr]
                                  .chars.each_with_index
                                  .select { |b, _| b == 'X' }
                                  .map { |_, i| i }

        %w[0 1].repeated_permutation(mask[:floating_indexes].size).each do |vals|
          derived_addr = mask[:addr]

          mask[:floating_indexes].zip(vals).each do |i, b|
            derived_addr[i] = b
          end

          mem[derived_addr.reverse.to_i(2)] = val
        end
      end
    when /mask/
      mask[:raw] = instr[1].reverse
      mask[:off] = 0
      mask[:on] = 0

      mask[:raw].chars.each_with_index do |bit, idx|
        next if bit == 'X'

        mask[bit == '0' ? :off : :on] |= (1 << idx)
      end
    end
  end

  mem.values.sum
end

puzzle1 = run(1)
puzzle2 = run(2)

puts [puzzle1, puzzle2]

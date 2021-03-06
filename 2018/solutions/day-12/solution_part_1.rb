require_relative('../../utils/data_reader.rb')
# Works for solution but not other example ones
GENERATION_COUNT=20

class SubterraneanSustainability
  include DataReader

  def initialize
    @input = read_data(File.dirname(__FILE__), 'input.txt')
    @state = @input[0].match(/ate: (.+)/).captures[0].split('')
    @notes = {}
    @pot_count = 0
    @starting_index = 0
  end

  def initialize_notes
    @input[2..-1].each do |row|
      key, value = row.match(/(.+) => (.)/).captures
      @notes[key.split('')] = value
    end
  end

  def output_state
    puts "#{@overall_count}: #{@state.join}: pots count #{@pot_count}"
  end

  def process_generation
    @new_state = []
    @state.each_with_index do |char, i|
      key = @state[i-2..i+2]
      new_char = @notes[key] || '.'
      @new_state[i] = new_char
    end
    @state=@new_state
  end

  def expand_state
    3.times do
      if @state[0..2] != ['.','.','.']
        @state.insert(0,'.')
        @starting_index -= 1
      end
      @state.push('.') if @state[-3..-1] != ['.','.','.']
    end
  end

  def count_pots
    @pot_count = 0
    index = @starting_index
    @state.each do |char|
      if char =='#'
        @pot_count += index
      end
      index += 1
    end
  end

  def call
    initialize_notes
    expand_state
    count_pots
    output_state
    GENERATION_COUNT.times do |i|
      expand_state
      process_generation
      count_pots
      output_state
    end
    puts "Final Pot Count", @pot_count
  end
end

SubterraneanSustainability.new.call

=begin
Tracking location in a hash for quick access

real    0m0.096s
user    0m0.062s
sys     0m0.016s
=end

=begin
Didn't need a part 2
Found this answer by looking at the outputs and inputs.
Once you get to 100 or so, each pattern was going up by 52.
At round 185, the count was 10539.
So to find the answer I did (50000000000 - 185) * 52 + 10539
=end


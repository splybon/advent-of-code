require_relative('../../utils/data_reader.rb')
include DataReader

class GuardTracker
  def initialize(input)
    @sorted_input = input.sort
    @guard_map = {}
  end

  def retrieve_capture_group(str, regex)
    str.match(regex).captures[0]
  end

  # map the guards to track their total sleep time and store the times they are sleeping
  def populate_guard_map
    current_guard = retrieve_capture_group(@sorted_input[0], /#(\d+)/)
    @sorted_input.each_cons(2) do |prev_line, line|
      case
      when line.include?('#')
        current_guard = retrieve_capture_group(line, /#(\d+)/)
      when line.include?('wakes up')
        prev_time = retrieve_capture_group(prev_line, /\d\d:(\S+)\]/)
        time = retrieve_capture_group(line, /\d\d:(\S+)\]/)
        @guard_map[current_guard] ||= {}

        # Storing total sleep now so don't have to loop through it again later
        @guard_map[current_guard][:total_sleep] ||= 0
        @guard_map[current_guard][:total_sleep] += (time.to_i - prev_time.to_i)

        # Sleep times is an array of the times they sleep
        @guard_map[current_guard][:sleep_times] ||= []
        @guard_map[current_guard][:sleep_times] << [prev_time.to_i, time.to_i - 1]
      end
    end
  end

  # Discover at which minute a guard is most often sleeping
  def find_most_asleep_time_for(guard_id)
    obj = {}
    @guard_map[guard_id][:sleep_times].each do |arr|
      (arr[0]..arr[1]).each do |num|
        obj[num] = (obj[num] || 0) + 1
      end
    end

    obj.max_by { |_k, v| v}[0]
  end

  # find max by the total sleep time for each guard
  def find_guard_with_most_sleep
    @guard_map.max_by { |_k, v| v[:total_sleep] }[0]
  end

  def process
    populate_guard_map
    guard_with_most_sleep = find_guard_with_most_sleep
    most_asleep_time = find_most_asleep_time_for guard_with_most_sleep
    puts "multiple: #{guard_with_most_sleep.to_i * most_asleep_time}"
  end
end

# Using class to track instance variables rather than having global ones
GuardTracker.new(read_data(File.dirname(__FILE__))).process

=begin
real    0m0.084s
user    0m0.058s
sys     0m0.018s
=end

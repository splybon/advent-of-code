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

        # Sleep times is an array of the times they sleep
        @guard_map[current_guard][:sleep_times] ||= []
        @guard_map[current_guard][:sleep_times] << [prev_time.to_i, time.to_i - 1]
      end
    end
  end

  def process_guards
    guard_sleep_times = {}

    # Select the minute for each guard that they are most often sleeping
    @guard_map.each do |guard_id, guard|
      obj = {}
      guard[:sleep_times].each do |arr|
        (arr[0]..arr[1]).each do |num|
          obj[num] = (obj[num] || 0) + 1
        end
      end
      max_time = obj.max_by { |_k, v| v}
      guard_sleep_times[guard_id] = {minute: max_time[0], frequency: max_time[1]}
    end

    # Find the guard with the greatest frequency out of all the guards
    most_sleepy_guard = guard_sleep_times.max_by do |guard_id, guard|
      guard[:frequency]
    end
    [most_sleepy_guard[0], most_sleepy_guard[1][:minute]]
  end

  def process
    populate_guard_map
    guard_id, minute = process_guards
    puts "multiple: #{guard_id.to_i * minute}"
  end
end

# Using class to track instance variables rather than having global ones
GuardTracker.new(read_data(File.dirname(__FILE__))).process

=begin
real    0m0.117s
user    0m0.068s
sys     0m0.024s
=end

require_relative('../../utils/data_reader.rb')

class MemoryManuever
  include DataReader

  def initialize
    input = read_data(File.dirname(__FILE__), 'input.txt')
    @data = input[0].split(' ').map(&:to_i)
    @meta_data = 0
  end

  def process_zero_child_node(index, meta_data_count, original_index)
    meta_data_start = index + 2
    meta_data_end = meta_data_start + meta_data_count
    @meta_data += @data.slice(meta_data_start, meta_data_count).inject(:+)
    meta_data_end
  end

  def add_child(index)
    original_index = index
    children = @data[index]
    meta_data_count = @data[index + 1]

    if children.zero?
      process_zero_child_node(index, meta_data_count, original_index)
    else
      children.times do |loop_count|
        # Account for if first child, include the original node
        additional_indices = loop_count.zero? ? 2 : 0
        index = add_child(index + additional_indices)
      end
      @meta_data += @data.slice(index, meta_data_count).inject(:+)
      # Returning higher index.  Index will always be increasing
      index + meta_data_count
    end
  end

  def call
    add_child(0)
    puts @meta_data
  end
end

MemoryManuever.new.call

=begin
real    0m0.035s
user    0m0.027s
sys     0m0.006s
=end


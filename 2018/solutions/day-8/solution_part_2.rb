require_relative('../../utils/data_reader.rb')

class MemoryManuever
  include DataReader

  def initialize
    input = read_data(File.dirname(__FILE__), 'input.txt')
    @data = input[0].split(' ').map(&:to_i)
  end

  def process_zero_child_node(index, meta_data_count, original_index)
    meta_data_start = index + 2
    meta_data_end = meta_data_start + meta_data_count
    value = @data.slice(meta_data_start, meta_data_count).inject(:+)
    [meta_data_end, value]
  end

  def add_child(index, root_node)
    original_index = index
    children_count = @data[index]
    meta_data_count = @data[index + 1]

    if children_count.zero?
      process_zero_child_node(index, meta_data_count, original_index)
    else
      children=(1..children_count).map do |loop_count|
        # Account for if first child, include the original node
        additional_indices = (loop_count == 1) ? 2 : 0
        index, value = add_child(index + additional_indices, false)
        value
      end

      # looks at child value and adds them to own value
      value = @data.slice(index, meta_data_count).map do |child|
        children[child-1] || 0
      end.inject(:+)

      puts "Root Node Value: #{value}" if root_node
      [index + meta_data_count, value]
    end
  end

  def call
    add_child(0, true)
  end
end

MemoryManuever.new.call

=begin
real    0m0.036s
user    0m0.029s
sys     0m0.006s
=end


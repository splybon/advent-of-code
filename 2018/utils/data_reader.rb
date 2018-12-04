module DataReader
  def read_data(file_path)
    File.readlines("#{file_path}/input.txt")
  end
end

# USE CASE
=begin
require_relative('../../utils/data_reader.rb')
include DataReader

read_data(File.dirname(__FILE__))
=end
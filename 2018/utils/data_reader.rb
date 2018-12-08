module DataReader
  def read_data(file_path, file='input.txt')
    File.readlines("#{file_path}/#{file}")
  end
end

# USE CASE
=begin
require_relative('../../utils/data_reader.rb')
include DataReader

read_data(File.dirname(__FILE__))
=end

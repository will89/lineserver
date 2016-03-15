class LineIndexer

  # Creates a file that is a list of unsigned long long (64 bit).
  # Each unsigned long long represents the offset of a start of line.
  # A final offset is written at the end of the file to mark where
  # the next line would have started. This makes it easier to compute
  # the start and end offsets of each line.
  # @param input_file [String] file to scan for line offsets
  # @param output_file [String] file to write line offsets of input_file
  # @return [Integer] number of lines in the input_file
  def self.create_line_index_file(input_filepath, output_filepath)
    indexed_file = File.open(input_filepath, 'r')
    line_offsets_file = File.open(output_filepath, 'w+')
    stat = indexed_file.stat
    offset = 0
    line_count = 1
    line_start = 0
    line_offsets_file.write([line_start].pack('Q'))
    while offset < stat.size
      indexed_file.sysread(stat.blksize).each_char.with_index do |char, index|
        if char == "\n"
          line_start = offset * stat.blksize + index + 1
          line_offsets_file.write([line_start].pack('Q'))
          line_count += 1
        end
      end
      offset += stat.blksize
    end
    line_offsets_file.write([stat.size + 1].pack('Q'))
    indexed_file.close
    line_offsets_file.close
    line_count
  end

  # Gets the line at the specified line_num without the newline character.
  # @param line_index_filepath [String] file that has the list of line offsets
  # @param input_filepath [String] file to serve lines from 
  # @param [Integer] 0 indexed line index
  # @return [String] the line at line <line_num> in input_filepath
  def self.get_line(line_index_filepath, input_filepath, line_num)
    line_index_file = File.open(line_index_filepath, 'r')
    line_index_file.seek(line_num * 8, IO::SEEK_SET)
    line_start, line_end = line_index_file.sysread(8 * 2).unpack('QQ')
    puts "#{line_start} - #{line_end}"
    input_file = File.open(input_filepath)
    input_file.seek(line_start)
    line = input_file.sysread(line_end - line_start - 1)
    line_index_file.close
    input_file.close
    line
  end
end

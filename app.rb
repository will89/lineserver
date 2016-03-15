require 'sinatra'
require 'config'
require './lib/line_indexer'

class LineServerApp < Sinatra::Base

  def initialize(line_count, line_offset_file)
    super()
    @line_count = line_count
    @line_offset_file = line_offset_file
  end

  get '/lines/:line_index' do
    begin
      line_index = Integer(params['line_index'])
      halt(413, '') if line_index >= @line_count
      LineIndexer.get_line(@line_offset_file, Settings.indexed_file, line_index)
    rescue ArgumentError
      status 400
      'Line Index must be an integer'
    end
  end

  not_found do
    status 404
    ''
  end

end

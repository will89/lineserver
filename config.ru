require './app'
require './lib/line_indexer'
require 'config'
require 'tempfile'

set :server, 'thin'

Config.load_and_set_settings(File.join('config', 'settings.yml'),
                             File.join('config', 'settings.local.yml'))

line_offset_file = Tempfile.new('line_offsets').path
line_count = LineIndexer.create_line_index_file(Settings.indexed_file, 
                                                line_offset_file)
run LineServerApp.new(line_count, line_offset_file)

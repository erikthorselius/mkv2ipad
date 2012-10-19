#!/usr/bin/env ruby
def find_mkv_files path
ARGV.each do |path|
  if File.directory? path
    puts "Dir"
  else
    puts "file"
  end
end

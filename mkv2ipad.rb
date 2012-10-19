#!/usr/bin/env ruby
require 'find'
def find_mkv_files argv
  files = []
  Find.find(argv) do |path|
    if FileTest.directory?(path)
      if File.basename(path)[0] == "."
        Find.prune       # Don't look any further into this directory.
      else
        next
      end
    else
      if File.extname(path).downcase == ".mkv"
        files << path
      end
    end
  end
  files
end

ARGV.each do |path|
  puts find_mkv_files path
end

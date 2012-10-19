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
        fork_to_ffmpeg(path,ipad_file_name(path))
      end
    end
  end
  files
end

def fork_to_ffmpeg(input_file, output_file) 
  puts input_file
  puts output_file
  command = "ffmpeg -i #{input_file} -acodec aac -ac 2 -strict experimental -ab 160k -s 1024x768 -vcodec libx264 -preset slow -level 31 -maxrate 10000000 -bufsize 10000000 -b 1200k -f mp4 -threads 0 #{output_file}"
  exec command
end
def ipad_file_name(input_file)
  filename = File.basename(input_file.downcase,".mkv")+".ipad.mp4"
  File.join(File.dirname(input_file),filename)
end
ARGV.each do |path|
  find_mkv_files path
end

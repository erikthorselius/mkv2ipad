#!/usr/bin/env ruby
require 'find'
require 'open3'
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
        rm_if_to_small(path,ipad_file_name(path))
        unless File.exists? ipad_file_name(path)
          #fork_to_ffmpeg(path,ipad_file_name(path))
        else 
          puts path
        end
      end
    end
  end
  files
end

def rm_if_to_small(input_file, output_file) 
  unless(File.size?(input_file).nil? or File.size?(output_file).nil?)
    if(File.size?(output_file) < File.size?(input_file)*0.15)
      puts "Remove output_file because it's to small"
      File.delete(output_file)
    end
  end
end
def fork_to_ffmpeg(input_file, output_file) 
  options = "-i #{input_file} -acodec aac -ac 2 -strict experimental -ab 160k -s 1024x768 -vcodec libx264 -preset slow -level 31 -maxrate 10000000 -bufsize 10000000 -b 1200k -f mp4 -threads 0 outputfile"
  Open3.popen3("ffmpeg", "-i", input_file, "-acodec", "aac", "-ac", "2", "-strict", "experimental","-ab","161k","-s","1024x768","-vcodec","libx264","-preset","slow","-level","31","-maxrate","10000000","-bufsize","10000000","-b","1200k","-f","mp4","-threads","0" , output_file) {|stdin, stdout, stderr, wait_thr|
    pid = wait_thr.pid # pid of the started process.
    stdout.each {|line|
      puts line
    }
    stderr.each {|line|
      puts line
    }
    exit_status = wait_thr.value # Process::Status object returned.
  }
end
def ipad_file_name(input_file)
  filename = File.basename(input_file,".mkv")+".ipad.mp4"
  File.join(File.dirname(input_file),filename)
end
ARGV.each do |path|
  find_mkv_files File.realpath(path)
end

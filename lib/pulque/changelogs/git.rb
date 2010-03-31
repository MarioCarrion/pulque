# Copyright (c) 2010 Mario Carrion <mario@carrion.mx>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'rubygems'
require 'git'

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "changelogs", "changelog")

module Pulque
  module ChangeLogs

    class GitChangeLog < ChangeLog
      def initialize(path)
        super(path)
        @name = "Git"
        @pwd_relative = nil
      end

      def print
        @pwd_relative="#{@path[@repo_path.length,@path.length-@repo_path.length]}"

        git = Git.open(@repo_path)

        added=[]
        deleted=[]
        modified=[]

        git.status.each do |file|
          added << file if file.type == 'A'
          deleted << file if file.type == 'D'
          modified << file if file.type == 'M'
        end

        main_array=[]
        format_array(main_array, added,     "# files added")
        format_array(main_array, deleted,   "# files deleted")
        format_array(main_array, modified,  "# files modified")

        if main_array.length > 0
          now = Date::today
          puts "#{now.year}-#{now.mon.to_s.rjust(2,'0')}-#{now.day.to_s.rjust(2,'0')}  #{git.config('user.name')}  <#{git.config('user.email')}>"
          puts
          main_array.each do |file| puts file end
        else
          puts "No changes found"
        end
      end

      def format_array(main_array, array, section_message)
        # Excluding files that are not in the same level
        files = []

        array.each do |file|
          if "#{file.path[0,@pwd_relative.length]}" == @pwd_relative
            files << remove_slash!(file.path[@pwd_relative.length, file.path.length-@pwd_relative.length])
          end
        end

        if files.length > 0
          files.sort!
          main_array << section_message
          files.each do |file|
            main_array << "\t* #{file}:"
          end
        end
      end

      def remove_slash!(file)
        if file[0,1] == "/"
          file = file [1,file.length-1]
        end
        file
      end
    end

    Pulque::ChangeLogs::Factory.register(Pulque::ChangeLogs::GitChangeLog)
  end
end

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

module Pulque
  module ChangeLogs

    class ChangeLog
      attr_accessor :path, :repo_path, :name

      def initialize(path)
        @path = path
        @pwd_relative = nil
        @repo_path = nil
        @name = nil
      end

      def get_author_details
         "#{get_date}  Username  <username@domain>"
      end

      def get_modified_files
        nil
      end

      def get_date
          now = Date::today
          "#{now.year}-#{now.mon.to_s.rjust(2,'0')}-#{now.day.to_s.rjust(2,'0')}"
      end

      # In case some repositories require special handling
      def format_path
        @pwd_relative=@path if @pwd_relative.nil?
      end

      def format_array(main_array, array, section_message)
        format_path
        # Excluding files that are not in the same level
        files = []

        array.each do |file|
          if "#{file[0,@pwd_relative.length]}" == @pwd_relative
            files << remove_slash!(file[@pwd_relative.length, file.length-@pwd_relative.length])
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

      def print
        modified_files = get_modified_files
        if modified_files.nil?
          puts "No ChangeLog implementation found."
        elsif modified_files.length == 0
          puts "No changes found."
        else
          puts "#{get_author_details}"
          puts
          modified_files.each do |file| puts file end
        end
      end
    end

  end
end

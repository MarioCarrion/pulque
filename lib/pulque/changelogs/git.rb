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
      end

      def get_author_details
        git = Git.open(@repo_path)
        "#{get_date}  #{git.config('user.name')}  <#{git.config('user.email')}>"
      end

      def get_modified_files
        git = Git.open(@repo_path)

        added=[]
        deleted=[]
        modified=[]

        git.status.each do |file|
          added << file.path if file.type == 'A'
          deleted << file.path if file.type == 'D'
          modified << file.path if file.type == 'M'
        end

        main_array=[]
        format_array(main_array, added,     "# files added")
        format_array(main_array, deleted,   "# files deleted")
        format_array(main_array, modified,  "# files modified")
	main_array
      end

      def format_path
        @pwd_relative="#{@path[@repo_path.length,@path.length-@repo_path.length]}" if @pwd_relative.nil?
      end

    end

    Pulque::ChangeLogs::Factory.register(Pulque::ChangeLogs::GitChangeLog)
  end
end

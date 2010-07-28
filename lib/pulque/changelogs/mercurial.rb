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

require 'systemu'

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "changelogs", "changelog")

module Pulque
  module ChangeLogs

    class MercurialChangeLog < ChangeLog
      def initialize(path)
        super(path)
        @name = "Mercurial"
      end

      def get_author_details
        username = ENV['HGUSER'] # TODO: Read ~/.hgrc and look for "username" entry
        email = ENV['EMAIL']

        if username.nil?
          username = ""
        end
        if email.nil?
          email = "#{ENV['USER']} #{ENV['HOST']}"
        end

        "#{get_date}  #{username}  <#{email}>"
      end

      def get_modified_files
        status, stdout, sterr = systemu("hg status #{@repo_path}")

        added=[]
        removed=[]
        modified=[]

        stdout.each do |file|
          f = file.chomp
          added << "/#{f[2,f.length - 1]}" if f[0,1] == 'A'
          removed << "/#{f[2,f.length - 1]}" if f[0,1] == 'R'
          modified << "/#{f[2,f.length - 1]}" if f[0,1] == 'M'
        end

        main_array=[]
        format_array(main_array, added,     "# files added")
        format_array(main_array, removed,   "# files removed")
        format_array(main_array, modified,  "# files modified")
        main_array
      end

      def format_path
        @pwd_relative="/"
      end

    end

    Pulque::ChangeLogs::Factory.register(Pulque::ChangeLogs::MercurialChangeLog)
  end
end

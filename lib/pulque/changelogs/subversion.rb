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

require 'svn/client'

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "changelogs", "changelog")

module Pulque
  module ChangeLogs

    class SubversionChangeLog < ChangeLog
      def initialize(path)
        super(path)
        @name = "Subversion"
      end

      def get_modified_files
        added=[]
        deleted=[]
        modified=[]

        context = Svn::Client::Context.new
        context.status(@path, "HEAD", true, true) do |file, status|
	  added << file if status.text_status == 4
	  deleted << file if status.text_status == 6
	  modified << file if status.text_status == 8
	end

        modified_files=[]
        format_array(modified_files, added,    "# files added")
        format_array(modified_files, deleted,  "# files deleted")
        format_array(modified_files, modified, "# files modified")
        modified_files
      end
    end

    Pulque::ChangeLogs::Factory.register(Pulque::ChangeLogs::SubversionChangeLog)
  end
end

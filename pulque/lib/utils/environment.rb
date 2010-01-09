# Copyright (c) 2009-2010 Mario Carrion <mario@carrion.mx>
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

require 'etc'
require 'fileutils'

module Pulque

  class Environment

    def Environment.create?(name,path=nil)
      path = File.join(Environment::format_path(path), name)
      return false if File.exists?(path) 

      begin
        FileUtils.mkdir_p(path)
      rescue SystemCallError => e
        return false
      end

      true
    end

    def Environment.exists?(name,path=nil)
      path = File.join(Environment::format_path(path), name)
      File.exists?(path) 
    end

    def Environment.format_path(path=nil)
      if path.nil?
        # FIXME: hardcoded path. hardcoded path separator?
        path = File.join(Etc::getpwuid.dir,".root-dev/")
      elsif path[-1].chr != "/"
        path += "/"
      end
      path
    end

    def Environment.list(path=nil)
      result = []
      path = Environment::format_path(path)
 
      if File.exists?(path)
        Dir.foreach(path) do |filename| 
	  if filename != "." && filename != ".." &&
	     File.directory?("#{path}#{filename}")
	    result << filename
	  end
        end
      end

      result
    end

    def Environment.remove?(name,path=nil)
      path = File.join(Environment::format_path(path), name)
      return false if !File.exists?(path) || !File.directory?(path)

      begin
        FileUtils.rm_rf(path)
      rescue SystemCallError 
        return false
      end

      true
    end
  end
 
end

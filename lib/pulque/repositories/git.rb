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

require 'rubygems'
require 'git'

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "repositories", "repository")

module Pulque
  # Detects Git repositories
  class GitRepository < Repository
    def initialize(path)
      super(path)
      @name = "Git"
      @friendly_name = "git"
      @branch = "$(__git_ps1 \"%s\")"
    end

    def detect?
      return false unless is_path_clean?

      detect_recursive?(@path)
    end

    # Git.open throws an exception when opening any path but "root"
    # so, we are trying to find the root here, we will store
    # this value to compare it later when calling detect again
    def detect_recursive?(path)
      return false if path == "/"

      begin
        git = Git.open(path)
      rescue ArgumentError => e
        split = path.split("/")
        split.delete_at(split.length - 1)
        result = ""
        split.each do |item|
          result = "#{result}#{item}/"
        end
        return detect_recursive?(result)
      end

      @repo_path = path
      true
    end
  end

  Pulque::Factory.register(Pulque::GitRepository)
end

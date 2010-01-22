#!/usr/bin/env ruby
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

require 'test/unit'

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib", "pulque", "repositories", "repository")

class RepositoryTest < Test::Unit::TestCase

  # Test values set in the constructor
  def test_ctr
    repo = Pulque::Repository.new("mypath")
    assert false if repo.path != "mypath"
    assert false if repo.repo_path != nil 
    assert false if repo.name != nil
    assert false if repo.friendly_name != nil
    assert false if repo.branch != nil
  end

  # Test if path is valid: exists and is directory
  def test_is_path_clean
    repo = Pulque::Repository.new("/usr/bin")
    # Path exists
    assert false if !repo.is_path_clean? 

    # Path does not exist
    repo.path = "/I/do/not/exist"
    assert false if repo.is_path_clean? 
   
    # Path is not path, is file
    repo.path = "/usr/bin/ls"
    assert false if repo.is_path_clean? 
  end

  # Test "virtual" method detect
  def test_detect
    repo = Pulque::Repository.new("nothing") 
    # By default is false
    assert false if repo.detect?
  end
end

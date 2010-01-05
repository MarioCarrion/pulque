# Copyright (c) 2009 Mario Carrion <mario@carrion.mx>
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

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "repositories", "repository")

# Hack to call 'require' using absolute path
# and catch LoadError exceptions
def require_loaderror(&block)
  begin 
    require File.join(File.expand_path(File.dirname(__FILE__)), "..", "repositories", block.call)
  rescue LoadError
  end
end

module Pulque
  
  class Factory
    @@repositories = {}
    
    def Factory.get_repositories(path)
      result = []
      @@repositories.values.each do |repository|
        result << repository.new(path)
      end
      result
    end

    def Factory.register(repository)
      @@repositories[repository.name] = repository
    end
  end

end

# Loading known repositories
require_loaderror { "git.rb" }
require_loaderror { "subversion.rb" }
require_loaderror { "mercurial.rb" }
require_loaderror { "bazaar.rb" }

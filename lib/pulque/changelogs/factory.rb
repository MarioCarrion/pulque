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

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "require_load")
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "repositories", "factory")

module Pulque
  module ChangeLogs

    class Factory
      @@changelogs = {}

      def Factory.get(path)
        repository = nil
        Pulque::Factory::get_repositories(path).each do |repo|
          if repo.detect?
            repository = repo
            break
          end
        end
        return ChangeLog.new(path) if repository.nil?

        changelog = nil
        @@changelogs.values.each do |changelog_type|
          changelog = changelog_type.new(path)
          if changelog.name == repository.name
            break
          end
          # Reset previous variable in case they are different
          changelog = nil
        end
        return ChangeLog.new(path) if changelog.nil?

        changelog.repo_path = repository.repo_path
        changelog
      end

      def Factory.register(changelog)
        @@changelogs[changelog.name] = changelog
      end
    end

  end
end

# Loading known implementations
require_loaderror("changelogs", "git.rb")
require_loaderror("changelogs", "subversion.rb")
require_loaderror("changelogs", "mercurial.rb")

EXTRA_DIST = LICENSE bin/* lib/* etc/* setup.rb

install:
	$(RUBY) ./setup.rb config --install-prefix $(DESTDIR) / 
	$(RUBY) ./setup.rb install

uninstall:
	$(RUBY) ./setup.rb --force uninstall

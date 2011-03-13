
MONGREL2_VER=mongrel2-1.4
MONGREL2_SRC=$(MONGREL2_VER).tar.bz2
ZMQ_VER=zeromq-2.0.8
ZMQ_SRC=$(ZMQ_VER).tar.gz

default: all

all: depends

pre-depends: stamps
	sudo apt-get install -y uuid-dev g++ libsqlite3-dev sqlite3 libjson0-dev

depends: pre-depends zeromq mongrel2

stamps:
	test -d stamps || mkdir stamps

zeromq: stamps/zeromq
stamps/zeromq: stamps
	test -d src || mkdir src
	cd src && \
	test -e $(ZMQ_SRC) || wget http://www.zeromq.org/local--files/area:download/$(ZMQ_SRC) ;\
	test -d $(ZMQ_VER) || tar xzf $(ZMQ_SRC); \
	cd $(ZMQ_VER) && ./configure && make && sudo make install && sudo ldconfig
	touch $@
	
mongrel2: stamps/mongrel2
stamps/mongrel2: stamps
	test -d src || mkdir src
	cd src && \
	test -e $(MONGREL2_SRC) || wget http://mongrel2.org/static/downloads/$(MONGREL2_SRC) ;\
	test -d $(MONGREL2_VER) || tar xjf $(MONGREL2_SRC); \
	cd $(MONGREL2_VER); \
	make clean all && sudo make install
	touch $@

mongrel2-cpp: src/mongrel2-cpp
	cd src/mongrel2-cpp && make && sudo make install

src/mongrel2-cpp:
	test -d src || mkdir src
	git clone https://github.com/akrennmair/mongrel2-cpp.git $@

test: mongrel2-cpp
	cd src/mongrel2-cpp && make

run:
	m2sh load -config test.conf -db test.sqlite
	m2sh start -db test.sqlite -host localhost

.PHONY: run

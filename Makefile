
default: all

all: pre-depends buildout mongrel2-cpp kwetter.core run

pre-depends: stamps
	sudo apt-get install -y uuid-dev g++ libsqlite3-dev sqlite3 libjson0-dev pkg-config flex

stamps:
	test -d stamps || mkdir stamps

kwetter.core: src/kwetter.core/kwetterd

src/kwetter.core/kwetterd: src/kwetter.core
	cd src/kwetter.core && \
		env ZMQ_CFLAGS="-I ../../parts/zeromq/include" ZMQ_LDFLAGS="-L ../../parts/zeromq/lib -lzmq" ZDB_CFLAGS="-I ../../parts/libzdb/include/zdb" ZDB_LDFLAGS="-L ../../parts/libzdb/lib -lzdb" make clean all

src/kwetter.core:
	test -d src || mkdir src
	git clone ssh://git.nfg.nl/var/git/kwetter.core $@

mongrel2-cpp: src/mongrel2-cpp/libm2pp.a

src/mongrel2-cpp/libm2pp.a: src/mongrel2-cpp
	cd src/mongrel2-cpp &&
		env PREFIX="-I ../../parts/mongrel2-cpp" OPTLIBS="-L ../../parts/zeromq/lib" make clean all install

src/mongrel2-cpp:
	test -d src || mkdir src
	git clone git://github.com/pjstevns/mongrel2-cpp.git $@

bin/python:
	virtualenv --no-site-packages --python=python2.6 --clear .

download-cache:
	[ -d download-cache ] || mkdir download-cache

bin/buildout: bin/python download-cache
	bin/easy_install zc.buildout

bin/supervisorctl: bin/buildout

buildout: bin/supervisorctl
	bin/buildout -N

run: kwetter.sqlite
	mkdir run

kwetter.sqlite:
	parts/mongrel2/bin/m2sh load -config kwetter.conf -db kwetter.sqlite
#	m2sh start -db kwetter.sqlite -host localhost

.PHONY: supervisor

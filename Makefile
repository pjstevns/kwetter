BUILDOUT_DIRECTORY:=$(PWD)

all: pre-depends buildout kwetter.core run

pre-depends: stamps
	sudo apt-get install -y uuid-dev g++ libsqlite3-dev sqlite3 libjson0-dev pkg-config flex python-virtualenv

stamps:
	test -d stamps || mkdir stamps

kwetter.core: src/mongrel2-cpp/libm2pp.a src/kwetter.core/kwetterd

src/kwetter.core/kwetterd: src/kwetter.core
	 cd src/kwetter.core && env \
		M2PP_CFLAGS="-I $(BUILDOUT_DIRECTORY)/parts/mongrel2-cpp/include" \
		M2PP_LDFLAGS="-L $(BUILDOUT_DIRECTORY)/parts/mongrel2-cpp/lib -Wl,-rpath -Wl,$(BUILDOUT_DIRECTORY)/parts/mongrel2-cpp/lib " \
		ZMQ_CFLAGS="-I $(BUILDOUT_DIRECTORY)/parts/zeromq/include" \
		ZMQ_LDFLAGS="-L $(BUILDOUT_DIRECTORY)/parts/zeromq/lib -Wl,-rpath -Wl,$(BUILDOUT_DIRECTORY)/parts/zeromq/lib -lzmq" \
		ZDB_CFLAGS="-I $(BUILDOUT_DIRECTORY)/parts/libzdb/include/zdb" \
		ZDB_LDFLAGS="-L $(BUILDOUT_DIRECTORY)/parts/libzdb/lib -Wl,-rpath -Wl,$(BUILDOUT_DIRECTORY)/parts/libzdb/lib -lzdb" \
		make clean all

src/kwetter.core:
	test -d src || mkdir src
	git clone git://github.com/pjstevns/kwetter.core $@

src/mongrel2-cpp/libm2pp.a: src/mongrel2-cpp
	cd src/mongrel2-cpp && env \
		PREFIX="$(BUILDOUT_DIRECTORY)/parts/mongrel2-cpp" \
		OPTLIBS="-L $(BUILDOUT_DIRECTORY)/parts/zeromq/lib -Wl,-rpath -Wl,$(BUILDOUT_DIRECTORY)/parts/zeromq/lib" \
		OPTFLAGS="-I $(BUILDOUT_DIRECTORY)/parts/zeromq/include" \
		make all install

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
	test -s var/kwetter.db || sqlite3 var/kwetter.db < src/kwetter.core/sql/db.sqlite

run: kwetter.sqlite
	mkdir run

kwetter.sqlite:
	parts/mongrel2/bin/m2sh load -config kwetter.conf -db kwetter.sqlite

.PHONY: supervisor

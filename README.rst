Kwetter microblogging buildout
==============================

This is an installer for the `kwetter.core <https://github.com/pjstevns/kwetter.core>`_
scalable microblogging engine.

You can use this "kwetter" buildout as a microblogging backend.

A subset of the backend functionality is available through a Plone integrated
frontend, see `collective.kwetter <https://github.com/gyst/collective.kwetter>`_


Installing kwetter
------------------

This documentation and accompanying scripts are based on an Ubuntu Lucid baseline.
You may have to adapt the required pre-dependencies if you're installing on a 
different platform. See the "pre-depends" target in the Makefile.

The following steps create a working kwetter installation:

1. checkout kwetter

::

     git clone ssh://github.com/pjstevns/kwetter


2. add debian.nfgd.net to your apt sources:

   libzdb is not yet available on debian/ubuntu. Packages can be gotten by adding 
   debian.nfgd.net your sources.list

::

     sudo echo "deb http://debian.nfgd.net/debian unstable main" >> /etc/apt/sources.list


3. run the installer script::

     cd kwetter
     make

4. run the kwetter daemons::

     bin/supervisord


5. verify daemon status::

     bin/supervisorctl status

This should show an output like::

     | kwetter-m2                       RUNNING    pid 5194, uptime 0:12:21
     | kwetterd                         RUNNING    pid 5195, uptime 0:12:21
     | mongrel2                         RUNNING    pid 5193, uptime 0:12:21

You now have a working system.

To shut down the system::

     bin/supervisorctl shutdown


Using kwetter
-------------

The JSON API is documented in the file `JSONAPI.rst <https://github.com/pjstevns/kwetter/blob/master/JSONAPI.rst>`_. 

See also the module doctests in `kwetter.core <https://github.com/pjstevns/kwetter.core>`_ for additional reference.


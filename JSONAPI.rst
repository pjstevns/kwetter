The Kwetter JSON API
====================

Data fields
-----------

command
  command to be called

result code for data modifications
* ``OK`` for success
* ``NO`` for failure
* ``ERR`` for server error

avatar
  user id

fullname
  user rendering name

follow
  another avatar, different from the command-issuing avatar

message
  a text message

messages
  a list of (avatar, message, timestamp) instances

timestamp
  a datetime without timezone speficied as a string, 
  in the format ``2011-05-13 11:57:37``


Commands
========

reg
---

Register a new avatar::

 {
 "command": "reg", 
 "avatar": "john", 
 "fullname": "John Doe"
 }

Returns ``OK`` or ``NO``.

unreg
-----

Remove an avatar from the registry::

 {
 "command": "unreg", 
 "avatar": "john"
 }

Unregistering an avatar will also purge all status messages sent by this avatar.

Returns ``OK`` or ``NO``.


rereg
-----

Update the entry of an avatar in the registry::

 {
 "command": "rereg",
 "avatar": "john",
 "newavatar":"john2",
 "newfullname": "John Doe Junior"
 }

Renames ``john`` to ``john2`` and updates the full name for this user.
No new avatar is created.

Returns ``OK`` or ``NO``.

info
----

Show fullname, followers and followees for avatar::

 {
 "command": "info",
 "avatar": "john2"
 }

Returns a (avatar, fullname, follows, followers) record::

 {
 "avatar": "infoname",
 "fullname":
 "Paul Stevens",
 "follows": ["follows", "follows2"],
 "followers": ["follower", "follower2"]
 }


follow
------

Subscribe to messages from another avatar::

 {
 "command": "follow",
 "avatar": "john2",
 "follow": "mary"
 }

This will subscribe ``john2`` to messages from ``mary``.

Returns ``OK`` or ``NO``.

unfollow
--------

Unsubscribe from another avatar::

 {
 "command": "unfollow",
 "avatar": "john2",
 "follow": "mary"
 }

This ends the stream of messages from ``mary`` to ``john2``.

Returns ``OK`` or ``NO``.


post
----

Post a new message::

 {
 "command": "post",
 "avatar": "john2",
 "message": "Lorem ipsum dolor sit amet."
 }

Sends the message string to all subscribers of ``john2``.

Returns ``OK`` or ``NO``.


search
------


Search for last ``limit`` messages since timestamp ``since`` containing ``string``::

 {
 "command": "search",
 "avatar" "john2",
 "string": "foobar",
 "since": "2011-05-06 13:48:20.595121",
 "limit": 10
 }

``string`` is optional. 
If omitted, all messages matching other critera are returned.

``since`` is optional.
If omitted, defaults to one week.

``limit`` is optional.
If omitted, defaults to 10 messages.

Returns the search arguments given plus a list of messages
in (avatar, message, timestamp) format::

 {
 "avatar" "john2",
 "string": "foobar",
 "since": "2011-05-06 13:48:20.595121",
 "limit": 10,
 "messages": [ 
   [ "mary", "other foobar message", "2011-05-06 11:57:37" ],
   [ "jane", "some foobar message", "2011-05-06 11:56:20" ] 
 ] }


timeline
--------

Show all messages of self and subscribed avatars since timestamp ``since``::

 {
 "command": "timeline",
 "avatar": "john2",
 "since": "2011-05-04 13:48:20.595121"
 }

``since`` is optional.
If omitted, defaults to one week.

Returns the timeline arguments given plus a list of messages
in (avatar, message, timestamp) format::

 {
 "avatar": "john2",
 "since": "2011-05-04 13:48:20.595121",
 "messages": [
   [ "mary", "foo message", "2011-05-13 11:57:38" ],
   [ "jane", "bar message", "2011-05-13 11:57:38" ],
   [ "john2", "foobar message", "2011-05-13 11:57:37" ]
 ] }
 

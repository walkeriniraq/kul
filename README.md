[![Gem Version](https://badge.fury.io/rb/kul.png)](http://badge.fury.io/rb/kul)
[![Build Status](https://travis-ci.org/walkeriniraq/kul.png?branch=master)](https://travis-ci.org/walkeriniraq/kul)
[![Dependency Status](https://gemnasium.com/walkeriniraq/kul.png)](https://gemnasium.com/walkeriniraq/kul)
[![Code Climate](https://codeclimate.com/github/walkeriniraq/kul.png)](https://codeclimate.com/github/walkeriniraq/kul)
[![Coverage Status](https://coveralls.io/repos/walkeriniraq/kul/badge.png?branch=master)](https://coveralls.io/r/walkeriniraq/kul)

Kul
===
(pronounced "Cool")

Description
-----------

Note! The 0.2.0 release changed some crucial parts, and the documentation has not been updated yet. Check
out [twitarr][] or the specs for current working.

Kul is designed to be a simpler web application framework. The goal is to merge the flexibility of something
like .JSPs with the power of Rails. It should be so easy to use that it can be a teaching / training tool for
people who don't know ruby, web development, or (maybe) even programming!

It is still a work in progress, but the gem is available on [rubygems][] for use in bundler.

The [wiki][] has all the information on how to use Kul.

Check out the [getting started][get-started] wiki article for the five minute explanation.

Planning and requirements
-------------------------
(more detail on my [blog][])

Currently the Ruby app server space is dominated by Rails, with Sinatra available for really simple web apps. From my
perspective, they are at opposite ends of the spectrum, with Rails doing MANY things for a developer, and Sinatra doing
few things.

Kul is designed to be somewhere in the middle. Implicit routing, a DSL for specifying controller actions, and some other
nifty features make building web apps easier. The goal is to never have to write a line of boiler plate code. A secondary
goal is to be able to add a new feature with as few file modifications as possible.

License
-------
Released under the MIT License.  See the [LICENSE][] file for further details.

[rubygems]: http://rubygems.org/gems/kul
[wiki]: http://github.com/walkeriniraq/kul/wiki
[get-started]: http://github.com/walkeriniraq/kul/wiki/Getting-Started
[blog]: http://blogs.rylath.net
[license]: LICENSE.txt
[twitarr]: http://github.com/walkeriniraq/twitarr
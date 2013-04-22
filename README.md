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

Kul is designed to be a simpler web application framework. The goal is to merge the flexibility of something
like .JSPs with the power of Rails. It should be so easy to use that it can be a teaching / training tool for
people who don't know ruby, web development, or (maybe) even programming!

It is still a work in progress, but the gem is available on [rubygems][] for use in bundler.

The [wiki][] has all the information on how to use Kul.

Check out the [getting started][get-started] wiki article for the five minute explanation.

Planning and requirements
-------------------------
(more detail on my [blog][])

Currently the Ruby app server space is dominated by Rails, with Sinatra providing backup. From my perspective, they are
at opposite ends of the spectrum, with Rails doing MANY things for a developer, and Sinatra doing few things.

Kul is designed to be somewhere in the middle. In the old days a web page was just an HTML file that lived on a server
somewhere - Kul tries to make web development that simple. Create a server and serve up some erbs. Add a folder and you
have implicit routing to the files there. Turn that folder into an application by adding a single ruby file. Add a
folder for application-specific implicit routing. And then add a controller to that folder for full MVC architecture.

License
-------
Released under the MIT License.  See the [LICENSE][] file for further details.

[rubygems]: https://rubygems.org/gems/kul
[wiki]: https://github.com/walkeriniraq/kul/wiki
[get-started]: https://github.com/walkeriniraq/kul/wiki/Getting-Started
[blog]: http://blogs.rylath.net
[license]: LICENSE.txt
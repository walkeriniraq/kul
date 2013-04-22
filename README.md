[![Gem Version](https://badge.fury.io/rb/kul.png)](http://badge.fury.io/rb/kul)
[![Dependency Status](https://gemnasium.com/walkeriniraq/kul.png)](https://gemnasium.com/walkeriniraq/kul)
[![Code Climate](https://codeclimate.com/github/walkeriniraq/kul.png)](https://codeclimate.com/github/walkeriniraq/kul)

Kul
===
(pronounced "Cool")

Description
-----------

Kul is designed to be a simpler web application framework. The goal is to merge the flexibility of something
like .JSPs with the power of Rails. It should be so easy to use that it can be a teaching / training tool for
people who don't know ruby, web development, or (maybe) even programming!

It is a work in progress, but feel free to check out and mess with it if you like.

The [wiki] has all the information on how to use Kul.

Planning and requirements
-------------------------
(more detail at [blogs.rylath.net](http://blogs.rylath.net))

Currently the Ruby app server space is dominated by Rails, with Sinatra providing backup. (Totally stole that joke.) From my
perspective, they are at opposite ends of the spectrum, with Rails doing MANY things for a developer, and Sinatra doing few
things. The few Sinatra apps I've built tend to have similar patterns, while in Rails I find myself repeatedly editing patterns
in order to accomplish what I want to do.

Kul is designed to be very agile. In the old days a web page was just an HTML file that lived on a server somewhere - Kul tries
to make web development that simple. Create a server and serve up some erbs. Add a folder and you have implicit routing
to the files there. Turn that folder into an application by adding a single ruby file. Add a folder for application-specific
implicit routing. And then add a controller to that folder for full MVC architecture.

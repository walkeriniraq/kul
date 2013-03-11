Kul
===
(pronounced "Cool")

Description
-----------

Kul is designed to be a simpler web application framework. The goal is to merge the flexibility of something
like .JSPs with the power of Rails.

It is a work in progress, but feel free to check out and mess with it if you like.

Planning and requirements
-------------------------
(excruciating details at blogs.rylath.net)

Currently the Ruby app server space is dominated by Rails, with Sinatra providing backup. (Totally stole that joke.) From my
perspective, they are at opposite ends of the spectrum, with Rails doing MANY things for a developer, and Sinatra doing few
things. The few Sinatra apps I've built tend to have similar patterns, while in Rails I find myself repeating edit patterns
in order to accomplish what I want to do.

Kul is designed to be very agile. In the old days a web page was just an HTML file that lived on a server somewhere - Kul tries
to make web development that simple. Create a server and serve up some erbs. Add a folder and you have implicit routing
to the files there. Turn that folder into an application by adding a single ruby file. Add a folder for application-specific
implicit routing. And then add a controller to that folder for full MVC architecture.

Near-term features:
- Rendering of .html.erb files as html files
- Compiling .js.coffee as javascript
- Compiling .css.sass as CSS
- Server / Application / Controller base classes and defaults
- Implicit routing to templates and actions
- ?

Long-term features:
- Simple SQL database API

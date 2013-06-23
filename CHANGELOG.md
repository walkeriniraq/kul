## 0.2.0
  - Added the ability to specify a whitelist for rack protection
  - Cleaned up the settings a bit

## 0.2.0
  - Applying the controller module to the request instance so that arbitrary helper functions can be executed
  - Moved controllers into 'app' folder - breaking change to library
  - Coffeescript and Sass are now cached inside the temp folder
  - Controller names now need to have "controller" appended to them
  - Changed the way that modules get applied to requests

## 0.1.5
  - Quick release to fix bug in non-jruby code

## 0.1.4
  - Models!
  - Fixed race condition in code reloading

## 0.1.3
  - Added setting to disable protection for bugfixing
  - Enabled logging

## 0.1.2
  - Improved handling of exceptions
  - Much improved code reloading
  - Server settings file
  - Use server settings to enable session
  - Responses now can define a content type
  - Helper for json responses
  - Fixed a bug where controller methods were not returning correctly
  - Fixed a bug in route listing

## 0.1.1
  - MVC lives again!
  - Can make post actions
  - Routes command will display the controller routes as well

## 0.1.0
  - Complete refactor of framework
  - All request now generate a RequestContext and return a response
  - Implemented server and app filters - not integrated with requests yet
  - JS and CSS requests now generate the correct response type
  - Tiny RISC-based ninjas defeat bugs in code
  - Basic example app now includes css, scss, js, and coffeescript

## 0.0.2

  - Code cleanup
  - Using HashInitialize for the request context
  - Added travis, gemnasium, codeclimate, and coveralls
  - Fixed a couple bugs
  - Added demo folder and basic example

## 0.0.1  (April 15, 2013)

Initial release. Basic features in place.
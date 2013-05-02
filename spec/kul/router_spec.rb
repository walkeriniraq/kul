require 'spec_helper'

describe Kul::RequestProcessor do
  context 'explicit routing' do
  end

  context 'implicit server routing' do

    #context 'files outside of the server path' do
    #  it 'returns 404' do
    #    inside_test_server do
    #      # it seems that sinatra fixes this itself - yay sinatra!
    #      get '/../not_reachable_file.html'
    #      last_response.should be_not_found
    #    end
    #  end
    #end
    #
    #context '.rb files' do
    #  it 'returns 404' do
    #    inside_test_server do
    #      get '/server.rb'
    #      last_response.should be_not_found
    #    end
    #  end
    #end
    #
    #context '.js files' do
    #  it 'returns the javascript file' do
    #    inside_test_server do
    #      get '/test.js'
    #      last_response.should be_ok
    #      last_response.body.should == "function foo() { alert('Hi'); }"
    #    end
    #  end
    #
    #  it 'returns 404 when the file is not present' do
    #    inside_test_server do
    #      get '/notexist.js'
    #      last_response.should be_not_found
    #    end
    #  end
    #
    #  it 'compiles and returns javascript from a .js.coffee file' do
    #    inside_test_server do
    #      get '/js/test_coffee.js'
    #      last_response.should be_ok
    #      last_response.body.should include 'window.foo = function()'
    #      last_response.body.should include "return alert('Hi');"
    #    end
    #  end
    #end
    #
    #context '.css files' do
    #  it 'returns the css file' do
    #    inside_test_server do
    #      get '/test.css'
    #      last_response.should be_ok
    #      #noinspection RubyResolve
    #      last_response.body.should include '.test {'
    #      last_response.body.should include 'color: blue;'
    #    end
    #  end
    #
    #  it 'returns 404 when the file is not present' do
    #    get '/notexist.css'
    #    last_response.should be_not_found
    #  end
    #
    #  it 'compiles and returns css from a .css.scss file' do
    #    inside_test_server do
    #      get '/css/test_sass.css'
    #      last_response.should be_ok
    #      last_response.body.should include '.test .foo'
    #      last_response.body.should include 'color: #00009b;'
    #    end
    #  end
    #end
    #
    #context 'html files' do
    #  it 'sends the html file content if it exists' do
    #    inside_test_server do
    #      get '/no_app/test.html'
    #      last_response.should be_ok
    #      last_response.body.should == 'Some random text'
    #    end
    #  end
    #
    #  it 'routes to the index.html file if a directory is specified' do
    #    inside_test_server do
    #      get '/foo/'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is another index.html!'
    #    end
    #  end
    #
    #  it 'routes to the server if the root is specified but no index file exists' do
    #    test_server_context('special_test_server') do
    #      get '/'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is my test'
    #    end
    #  end
    #
    #  it 'routes to the index.html if a folder is specified but no index file exists' do
    #    test_server_context('special_test_server') do
    #      get '/foo'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is my other test'
    #    end
    #  end
    #
    #  it 'routes to the server in the public folder if html does not exist' do
    #    inside_test_server do
    #      get '/public/test.html'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is my test'
    #    end
    #  end
    #
    #  it 'routes to the server in the views folder if html does not exist' do
    #    inside_test_server do
    #      get '/views/test.html'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is my test'
    #    end
    #  end
    #
    #  it 'routes to the index.html for the root' do
    #    inside_test_server do
    #      get '/'
    #      last_response.should be_ok
    #      last_response.body.should == 'This is the index.html!'
    #    end
    #  end
    #
    #  it 'routes to the server when no html file present' do
    #    server = stub
    #    server.should_receive(:route_path).with("non_exist", an_instance_of(Hash)) { "foo" }
    #    Kul::FrameworkFactory.should_receive(:create_server) { server }
    #    get '/non_exist.html'
    #    last_response.should be_ok
    #    last_response.body.should == "foo"
    #  end
    #end
    #
    #context 'controller action' do
    #  it 'routes to the server and renders the response' do
    #    server = stub
    #    server.should_receive(:route_action).and_return ResponseText.new(text: 'foo')
    #    Kul::FrameworkFactory.should_receive(:create_server) { server }
    #    get '/foo/bar/baz'
    #    last_response.should be_ok
    #    last_response.body.should == "foo"
    #  end
    #
    #  it 'passes a request context to the server' do
    #    server = stub
    #    server.should_receive(:route_action).with(an_instance_of(Kul::RequestContext)).and_return ResponseText.new(text: 'bar')
    #    Kul::FrameworkFactory.should_receive(:create_server) { server }
    #    get '/foo/bar/baz'
    #    last_response.should be_ok
    #    last_response.body.should == "bar"
    #  end
    #
    #  it 'passes GET as the verb when it is called as get' do
    #    pending
    #  end
    #
    #  it 'passes POST as the verb when it is called as post'
    #end
  end
end

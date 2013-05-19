require 'spec_helper'

describe Kul::Route do

  describe '#server' do
    let(:request) { Kul::Route.new(:GET, path: '') }
    it 'should return a server' do
      request.server.should be_a Kul::BaseServer
    end
    it 'should return the same server' do
      test = request.server
      test.should be_equal request.server
    end
  end

  describe '#app' do
    let(:route) { Kul::Route.new(:GET, 'foo/bar/baz?test=thing') }
    it 'should return an app' do
      route.app.should be_a Kul::BaseApp
    end
    it 'should return the same app' do
      test = route.app
      test.should be_equal route.app
    end
  end

  describe '#controller' do
    let(:route) { Kul::Route.new(:GET, 'foo/bar/baz?test=thing') }
    it 'should return a controller module' do
      inside_test_server do
        route.controller.should be_a Module
      end
    end
    it 'should return the correct module' do
      inside_test_server do
        route.controller.should == Foo::Bar
      end
    end
  end

  describe '#has_action?' do
    it 'should return true for a valid action' do
      inside_test_server do
        request = Kul::Route.new(:GET, 'foo/bar/test_action?test=thing')
        request.has_action?.should be_true
      end
    end
    it 'should return false if no action' do
      inside_test_server do
        request = Kul::Route.new(:PUT, 'foo/bar/test_action?test=thing')
        request.has_action?.should be_false
      end
    end
    it 'should return false if no controller module' do
      inside_test_server do
        request = Kul::Route.new(:GET, 'foo/baz/test_action?test=thing')
        request.has_action?.should be_false
      end
    end
    it 'should return false if not an actionize model' do
      module Bar
        module Baz
          def test_action
            'foo'
          end
        end
      end
      request = Kul::Route.new(:GET, 'bar/baz/test_action?test=thing')
      request.has_action?.should be_false
    end
  end

end
require 'spec_helper'

describe Kul::FrameworkFactory do

  context '#create_server' do
    context 'when there is no server.rb file' do
      it 'should return a server object' do
        inside_empty_server do
          test = Kul::FrameworkFactory.create_server
          test.should be_a Kul::BaseServer
        end
      end
    end

    context 'when the Server class is defined in the server.rb' do
      it 'should return the correct server object' do
        inside_test_server do
          test = Kul::FrameworkFactory.create_server
          test.should be_a Server
        end
      end
    end

    context 'when the Server class is not defined in the server.rb' do
      it 'should return a Kul::Server object' do
        test_server_context('special_test_server') do
          test = Kul::FrameworkFactory.create_server
          test.should be_a Kul::BaseServer
          Kernel.method_defined? :some_random_function
        end
      end
    end
  end

  context '#find_module' do
    it 'returns nil if the controller file does not exist' do
      inside_empty_server do
        test = Kul::FrameworkFactory.find_module 'test', 'more_test'
        test.should be_nil
      end
    end
    it 'returns nil if the folder structure does not exist' do
      inside_empty_server do
        test = Kul::FrameworkFactory.find_module 'foo', 'bar'
        test.should be_nil
      end
    end
    
    it 'returns the module from the file if it exists' do
      inside_test_server do
        test = Kul::FrameworkFactory.find_module 'foo', 'bar'
        test.should be
        test.should be_a Module
        test.to_s.should == 'Foo::Bar'
      end
    end
  end

  context '#create_app' do
    it 'creates an app instance' do
      inside_test_server do
        test = Kul::FrameworkFactory.new.create_app 'foo'
        test.should be
        test.should be_a FooApp
      end
    end

    it 'creates a base app if there is no app file present' do
      inside_test_server do
        test = Kul::FrameworkFactory.new.create_app 'no_app'
        test.should be
        test.should be_a Kul::BaseApp
      end
    end
  end
end
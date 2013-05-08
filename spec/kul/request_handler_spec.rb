require 'spec_helper'

describe Kul::RequestHandler do
  
  class TestRequestHandler
    attr_accessor :before_filters, :after_filters, :around_filters
    include Kul::RequestHandler
    def request_handler(request)
      request
    end
  end

  describe '#handle_request' do
    it 'runs the before filters' do
      server = TestRequestHandler.new
      server.should_receive(:run_before_filters).with({})
      server.handle_request({})
    end
    context 'when the before_filters return a response' do
      it 'returns the response' do
        server = TestRequestHandler.new
        server.stub(:run_before_filters => 'bar')
        test = server.handle_request('foo')
        test.should == 'bar'
      end
    end
    context 'when before_filters return nil' do
      it 'runs the around filters' do
        server = TestRequestHandler.new
        server.should_receive(:run_around_filters).with('foo')
        server.handle_request('foo')
      end
      it 'runs the after filters' do
        server = TestRequestHandler.new
        server.should_receive(:run_after_filters).with({}, {})
        server.handle_request({})
      end
      it 'returns the response from the around_filters' do
        server = TestRequestHandler.new
        server.should_receive(:run_around_filters).with('foo').and_return 'bar'
        test = server.handle_request('foo')
        test.should == 'bar'
      end
    end
    it 'runs the request_handler after the filters' do
      server = TestRequestHandler.new
      server.should_receive(:request_handler) { |request| 'foo' }
      test = server.handle_request({})
      test.should == 'foo'
    end
  end

  describe '#run_before_filters' do
    subject(:server) do
      server = TestRequestHandler.new
    end
    it 'returns nil when no filters' do
      test = server.run_before_filters('foo')
      test.should be_nil
    end
    context 'given two before filters' do
      class TestFilterOne
        @@count = 0
        attr_accessor :filter_run, :context

        def filter(context)
          @filter_run = @@count = @@count + 1
          @context = context
          nil
        end
      end
      class TestFilterTwo < TestFilterOne
        def filter(context)
          super(context)
          return 'test return value'
        end
      end
      subject(:server) do
        server = TestRequestHandler.new
        server.before_filters = [TestFilterOne.new, TestFilterOne.new]
        server.run_before_filters('foo')
        server
      end
      it 'runs the first filter' do
        server.before_filters[0].filter_run.should_not be_nil
      end
      it 'runs the second filter' do
        server.before_filters[1].filter_run.should_not be_nil
      end
      it 'runs the second filter after the first' do
        server.before_filters[1].filter_run.should be > server.before_filters[0].filter_run
      end
      it 'passes the request context to the filter' do
        server.before_filters[1].context.should == 'foo'
      end
      it 'returns nil' do
        test = server.run_before_filters('bar')
        test.should be_nil
      end
      context 'when the first filter returns a response' do
        subject(:server) do
          server = TestRequestHandler.new
          server.before_filters = [TestFilterTwo.new, TestFilterOne.new]
          server
        end
        it 'does not run the second filter' do
          server.run_before_filters('foo')
          server.before_filters[1].filter_run.should be_nil
        end
        it 'returns the response' do
          test = server.run_before_filters('foo')
          test.should == 'test return value'
        end
      end
      context 'when the second filter returns a response' do
        subject(:server) do
          server = TestRequestHandler.new
          server.before_filters = [TestFilterOne.new, TestFilterTwo.new]
          server
        end
        it 'runs the first filter' do
          server.run_before_filters('bar')
          server.before_filters[0].filter_run.should_not be_nil
        end
        it 'returns the response' do
          test = server.run_before_filters('foo')
          test.should == 'test return value'
        end
      end
    end
    context 'given a proc filter' do
      let(:filter) do
        Proc.new do |params|
          params[:run_count] += 1
          nil
        end
      end
      it 'runs the filter' do
        server.before_filters = [filter]
        params = { :run_count => 0 }
        server.run_before_filters(params)
        params[:run_count].should == 1
      end
      it 'returns the response' do
        filter = Proc.new do |params|
          params
        end
        server.before_filters = [filter]
        test = server.run_before_filters('foo')
        test.should == 'foo'
      end
      it 'returns nil if no response' do
        server.before_filters = [filter]
        test = server.run_before_filters({ :run_count => 0 })
        test.should be_nil
      end
    end
    it 'throws an error if passed an invalid filter' do
      server.before_filters = ['bar']
      expect { server.run_before_filters('foo') }.to raise_error('Invalid filter type passed in.')
    end

    context 'given a lambda filter' do
      let(:filter) do
        lambda do |params|
          params[:run_count] += 1
          nil
        end
      end
      it 'runs the filter' do
        server.before_filters = [filter]
        params = { :run_count => 0 }
        server.run_before_filters(params)
        params[:run_count].should == 1
      end
    end
  end

  describe '#run_after_filters' do
    subject(:server) do
      server = TestRequestHandler.new
    end

    context 'given two after filters' do
      class TestAfterFilterOne
        @@count = 0
        attr_accessor :filter_run, :context, :response

        def filter(context, response)
          @filter_run = @@count = @@count + 1
          @context = context
          @response = response
          nil
        end
      end

      subject(:server) do
        server = TestRequestHandler.new
        server.after_filters = [TestAfterFilterOne.new, TestAfterFilterOne.new]
        server.run_after_filters('foo', 'bar')
        server
      end

      it 'runs the first filter' do
        server.after_filters[0].filter_run.should_not be_nil
      end
      it 'runs the second filter' do
        server.after_filters[1].filter_run.should_not be_nil
      end
      it 'runs the second filter after the first' do
        server.after_filters[1].filter_run.should be > server.after_filters[0].filter_run
      end
      it 'passes the context to the filter' do
        server.after_filters[0].context.should == 'foo'
      end
      it 'passes the response to the filter' do
        server.after_filters[0].response.should == 'bar'
      end
    end

    it 'throws an error when given an invalid filter' do
      server.after_filters = ['sadf']
      expect { server.run_after_filters('foo', 'bar') }.to raise_error 'Invalid filter type passed in.'
    end
    it 'runs a proc filter' do
      run_count = 0
      filter = Proc.new do |_|
        run_count += 1
        nil
      end
      server.after_filters = [filter]
      server.run_after_filters 'foo', 'bar'
      run_count.should be 1
    end
  end

  describe '#run_around_filters' do
    class TestAroundFilterOne
      @@count = 0
      attr_accessor :filter_run, :context, :response

      def filter(context)
        @filter_run = @@count = @@count + 1
        @context = context
        @response = yield
      end
    end

    context 'given two around_filters' do
      subject(:server) do
        server = TestRequestHandler.new
        server.around_filters = [TestAroundFilterOne.new, TestAroundFilterOne.new]
        server.run_around_filters 'foo'
        server
      end

      it 'runs the first filter' do
        server.around_filters[0].filter_run.should_not be_nil
      end
      it 'runs the second filter' do
        server.around_filters[1].filter_run.should_not be_nil
      end
      it 'runs the first filter around the second filter' do
        server.around_filters[1].filter_run.should be > server.around_filters[0].filter_run
      end
    end
    it 'returns the response from the filter' do
      server = TestRequestHandler.new
      server.around_filters = [TestAroundFilterOne.new, TestAroundFilterOne.new]
      test = server.run_around_filters 'foo'
      test.should == 'foo'
    end
    it 'runs a proc filter' do
      filter = Proc.new do |params|
        params[:run_count] += 1
        nil
      end
      server = TestRequestHandler.new
      server.around_filters = [filter]
      request = { :run_count => 0 }
      server.run_around_filters request
      request[:run_count].should == 1
    end
    it 'throws an error when given an invalid filter' do
      server = TestRequestHandler.new
      server.around_filters = ['foo']
      expect { server.run_around_filters 'bar' }.to raise_error('Invalid filter type passed in.')
    end
    it 'passes an error up the stack' do
      class TestExceptionHandler
        attr_accessor :before_filters, :after_filters, :around_filters
        include Kul::RequestHandler
        def request_handler(request)
          raise 'test error'
        end
      end

      server = TestExceptionHandler.new
      server.around_filters = [TestAroundFilterOne.new]
      expect { server.run_around_filters 'bar' }.to raise_error('test error')
    end
    it 'takes a lambda for the method' do
      server = TestRequestHandler.new
      server.around_filters = [TestAroundFilterOne.new]
      test = server.run_around_filters('foo')
      test.should == 'foo'
    end
  end
end
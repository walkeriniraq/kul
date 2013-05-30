require 'spec_helper'

describe Kul::Actionize do

  context 'given a module with nothing defined' do
    module EmptyActionTest
      actionize!
    end

    it 'returns empty set for #list_actions' do
      EmptyActionTest.list_actions.should be
      EmptyActionTest.list_actions.should be_empty
    end

    it 'returns false for #action_exists?' do
      module EmptyActionTest2
        actionize!
      end
      EmptyActionTest2.action_exists?(:foo, :GET).should be_false
    end

  end

  context 'given a module that has actions' do
    module ActionTest
      actionize!

      get 'foo' do
        'bar'
      end

      get 'baz' do
        self[:foo]
      end

      get 'test' do
        return 'foo'
      end

      get 'call_helper' do
        helper_method
      end

      def helper_method
        'foobarbaz'
      end

    end

    it 'has a value return properly' do
      instance = {}
      test = ActionTest.execute_action instance, 'test', :GET
      test.should == 'foo'
    end

    it 'indicates that actions exist' do
      ActionTest.action_exists?('foo', :GET).should be_true
    end

    it 'indicates that actions do not exist' do
      ActionTest.action_exists?('bar', :GET).should be_false
    end

    describe '#list_actions' do
      subject { ActionTest.list_actions }
      it { should include :foo }
      it { should include :baz }
    end

    it 'creates get methods with the GET verb' do
      test = ActionTest.list_actions[:foo][:GET]
      test.should be
    end

    it 'can have its methods executed' do
      instance = {}
      test = ActionTest.execute_action instance, 'foo', :GET
      test.should == 'bar'
    end

    it 'executes in the context of the instance' do
      instance = { foo: 'baz' }
      test = ActionTest.execute_action instance, 'baz', :GET
      test.should == 'baz'
    end

    it 'can call a helper method' do
      instance = {}
      test = ActionTest.execute_action instance, 'call_helper', :GET
      test.should == 'foobarbaz'
    end
  end

  describe 'various action verb methods' do
    module VerbActionTest
      actionize!
      post 'foo' do
        'bar'
      end
      delete 'foo' do
        'baz'
      end
      put 'bar' do
        'foo'
      end
      head 'baz' do
        'blah'
      end
      options 'yay' do
        'done'
      end
    end

    it 'adds POST actions' do
      VerbActionTest.action_exists?('foo', :POST).should be_true
      VerbActionTest.list_actions[:foo][:POST].should be
      instance = {}
      test = VerbActionTest.execute_action instance, 'foo', :POST
      test.should == 'bar'
    end
    it 'adds DELETE actions' do
      VerbActionTest.action_exists?('foo', :DELETE).should be_true
      VerbActionTest.list_actions[:foo][:DELETE].should be
      instance = {}
      test = VerbActionTest.execute_action instance, 'foo', :DELETE
      test.should == 'baz'
    end
    it 'adds PUT actions' do
      VerbActionTest.action_exists?('bar', :PUT).should be_true
      VerbActionTest.list_actions[:bar][:PUT].should be
      instance = {}
      test = VerbActionTest.execute_action instance, 'bar', :PUT
      test.should == 'foo'
    end
    it 'adds HEAD actions' do
      VerbActionTest.action_exists?('baz', :HEAD).should be_true
      VerbActionTest.list_actions[:baz][:HEAD].should be
      instance = {}
      test = VerbActionTest.execute_action instance, 'baz', :HEAD
      test.should == 'blah'
    end
    it 'adds OPTIONS actions' do
      VerbActionTest.action_exists?('yay', :OPTIONS).should be_true
      VerbActionTest.list_actions[:yay][:OPTIONS].should be
      instance = {}
      test = VerbActionTest.execute_action instance, 'yay', :OPTIONS
      test.should == 'done'
    end
  end
end

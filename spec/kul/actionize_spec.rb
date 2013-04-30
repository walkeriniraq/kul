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
      EmptyActionTest2.action_exists?(:foo).should be_false
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
    end

    it 'indicates that actions exist' do
      ActionTest.action_exists?('foo').should be_true
    end

    it 'indicates that actions do not exist' do
      ActionTest.action_exists?('bar').should be_false
    end

    describe '#list_actions' do
      subject { ActionTest.list_actions }
      it { should include :foo }
      it { should include :baz }
    end

    it 'creates get methods with the GET verb' do
      test = ActionTest.list_actions[:foo]
      test.should be
      test[:verb].should == :GET
    end

    it 'creates HEAD methods for the GET methods' do
      pending
    end

    it 'can have its methods executed' do
      instance = {}
      test = ActionTest.execute_action instance, 'foo'
      test.should == 'bar'
    end

    it 'executes in the context of the instance' do
      instance = { foo: 'baz' }
      test = ActionTest.execute_action instance, 'baz'
      test.should == 'baz'
    end
  end

  it 'adds POST actions' do
    module PostActionTest
      actionize!
      post 'foo' do
        'bar'
      end
    end
    PostActionTest.action_exists?('foo').should be_true
    PostActionTest.list_actions[:foo].should be
    PostActionTest.list_actions[:foo][:verb].should == :POST
    instance = {}
    test = PostActionTest.execute_action instance, 'foo'
    test.should == 'bar'
  end

  it 'adds DELETE actions'
  it 'adds PUT actions'
  it 'adds HEAD actions'
  it 'adds OPTIONS actions'

end

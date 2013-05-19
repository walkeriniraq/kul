require 'spec_helper'

describe Kul::RouteTypeList do

  context 'default router' do
    context '#handle_extension?' do
      it 'returns true for .js files' do
        described_class.new.handle_type?('js').should be_true
      end
      it 'returns true for .html files' do
        described_class.new.handle_type?('html').should be_true
      end
      it 'returns true for .css files' do
        described_class.new.handle_type?('css').should be_true
      end
      it 'returns false for .rb files' do
        described_class.new.handle_type?('rb').should be_false
      end
      it 'returns true for test.html files' do
        described_class.new.handle_type?('test.html').should be_true
      end
    end
  end

  describe '#valid_extensions' do
    let(:router) { Kul::FrameworkFactory.get_route_type_list }
    subject { router.valid_types }

    it { should include 'html' => 'html' }
    it { should include 'html.erb' => 'html' }
    it { should include 'js' => 'js' }
    it { should include 'js.coffee' => 'js' }
    it { should include 'css' => 'css' }
    it { should include 'css.sass' => 'css' }
    it { should include 'css.scss' => 'css' }

    context 'extra extensions' do
      it 'should include the extra extensions' do
        router = Kul::FrameworkFactory.get_route_type_list
        router.add_route_type 'foo', { :instruction => :file }
        router.add_route_type 'foo', { :extra_extension => '.bar', :instruction => :file }
        test = router.valid_types
        test.should include 'foo' => 'foo'
        test.should include 'foo.bar' => 'foo'
      end
    end
  end

  context 'explicit routing' do
  end

  context 'implicit server routing' do
  end
end

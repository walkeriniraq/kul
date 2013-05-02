RSpec::Matchers.define :contain_all do |expected|
  match do |actual|
    check_contains expected, actual
  end

  def check_contains(expected, actual)
    if actual.is_a?(Hash) && expected.is_a?(Hash)
      expected.each do |k, v|
        return false unless actual.include? k
        return false unless check_contains v, actual[k]
      end
    else
      return expected == actual
    end
    true
  end
end

module RSpec::Matchers
  alias_method :hash_containing, :contain_all
end

describe 'contain_all matcher' do
  it 'should match strings' do
    'a'.should contain_all 'a'
    'a'.should_not contain_all 'b'
  end
  it 'should match simple hashes' do
    { a: 'b', c: 'd' }.should contain_all a: 'b', c: 'd'
    { a: 'b', c: 'd' }.should_not contain_all a: 'b', c: 'd', e: 'f'
  end
  it 'should allow the actual to contain more than the expected' do
    { a: 'b', c: 'd', e: 'f' }.should contain_all a: 'b', c: 'd'
    { a: 'b', e: 'f' }.should_not contain_all a: 'b', c: 'd'
  end
  it 'should match recursively' do
    { a: 'b', c: { d: 'e', f: 'g' } }.should contain_all a: 'b', c: { d: 'e' }
    { a: 'b', c: { d: 'e' } }.should_not contain_all a: 'b', c: { d: 'e', f: 'g' }
  end
  it 'should respond to hash_contains_all' do
    { a: 'b', c: { d: 'e', f: 'g' } }.should hash_containing a: 'b', c: { d: 'e' }
    { a: 'b', c: { d: 'e' } }.should_not hash_containing a: 'b', c: { d: 'e', f: 'g' }
  end
end

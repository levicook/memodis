require 'teststrap'

context Memodis do
  setup { Memodis }
  asserts(:constants).includes('Memoizable')
  asserts(:constants).includes('WeakCache')
end

context "Exteding Memodis" do
  setup { Object.new.extend(Memodis) }
  asserts(:methods).includes('memoize')
end


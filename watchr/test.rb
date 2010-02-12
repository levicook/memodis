
watch( 'test/teststrap.rb' ) { |md| system("ruby -Ilib -Itest test/*_test.rb") }
watch( 'test/.*_test.rb' )   { |md| system("ruby -Ilib -Itest #{md[0]}") }
watch( 'lib/(.*)\.rb' )      { |md| system("ruby -Ilib -Itest test/#{md[1]}_test.rb") }

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest', all_on_start: true do
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }

  watch(%r{^app/(.+)\.rb$})   { |m| "test/app/#{m[1]}_test.rb" }
  watch(%r{^lib/(.+)\.rb$})   { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/(.+)\.rb$})  { |m| "test/#{m[1]}.rb" }
end

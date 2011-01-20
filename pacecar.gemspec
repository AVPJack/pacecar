Gem::Specification.new do |s|
  s.name = 'pacecar'
  s.version = '1.4.5'
  s.date = %q{2011-01-20}
  s.email = 'mjankowski@thoughtbot.com'
  s.homepage = 'http://github.com/thoughtbot/pacecar'
  s.summary = 'Pacecar adds scope methods to ActiveRecord classes via database column introspection.'
  s.description = 'Generated scopes for ActiveRecord classes.'
  s.files = ["init.rb", "README*", "MIT-LICENSE", "{lib/**/*}"].map { |glob| Dir[glob] }.flatten
  s.authors = ['Matt Jankowski']
end

rails_versions = ['3.0.10', '3.1.0']
database_drivers = ['mysql', 'sqlite3-ruby', 'pg', 'sqlite3']

rails_versions.each do |rails_version|
  database_drivers.each do |database_driver|
    appraise "rails-#{rails_version}-database-#{database_driver}" do
      gem "rails", rails_version
      gem database_driver
    end
  end
end

# The mysql2 gem needs different versions depending on which activerecord we have
appraise "rails-3.1.0-database-mysql2" do
  gem "rails", "3.1.0"
  gem "mysql2", "0.3.7"
end

appraise "rails-3.0.10-database-mysql2" do
  gem "rails", "3.0.10"
  gem "mysql2", "0.2.13"
end

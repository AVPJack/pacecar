require 'test_helper'

class SearchTest < Test::Unit::TestCase

  context "A class which has included Pacecar" do
    setup do
      @class = User
    end
    should "set the correct expected values for a _equals column method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} = 'test')
      SQL
      assert_equal expected.strip, @class.first_name_equals('test').to_sql
    end
    should "set the correct expected values for a _equals column method with an Array as value" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} IN ('test', 'this'))
      SQL
      assert_equal expected.strip, @class.first_name_equals(['test','this']).to_sql
    end
    should "set the correct expected values for a _equals column method with nil as value" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} IS NULL)
      SQL
      assert_equal expected.strip, @class.first_name_equals(nil).to_sql
    end
    should "set the correct expected values for a _matches column method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE '%test%')
      SQL
      assert_equal expected.strip, @class.first_name_matches('test').to_sql
    end
    should "set the correct expected values for a _starts_with column method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE 'test%')
      SQL
      assert_equal expected.strip, @class.first_name_starts_with('test').to_sql
    end
    should "set the correct expected values for a _ends_with column method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE '%test')
      SQL
      assert_equal expected.strip, @class.first_name_ends_with('test').to_sql
    end
    should "set the correct expected values for a search_for method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE '%test%' OR #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("last_name")} LIKE '%test%' OR #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("description")} LIKE '%test%')
      SQL
      assert_equal expected.strip, @class.search_for('test').to_sql
    end
    should "set the correct expected values for a search_for method with :on option" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE '%test%' OR #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("description")} LIKE '%test%')
      SQL
      assert_equal expected.strip, @class.search_for('test', :on => [:first_name, :description]).to_sql
    end
    should "set the correct expected values for a search_for method with an :require option" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("first_name")} LIKE '%test%' AND #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("last_name")} LIKE '%test%' AND #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name("description")} LIKE '%test%')
      SQL
      assert_equal expected.strip, @class.search_for('test', :require => :all).to_sql
    end
  end

  context "A class which has included Pacecar but which has nothing to search" do
    setup do
      @class = Mammal
    end
    should "set the correct expected values for a search_for method" do
      expected =<<-SQL
      SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name}
      SQL
      assert_equal expected.strip, @class.search_for('test').to_sql
    end
  end

end

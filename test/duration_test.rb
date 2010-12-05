require 'test_helper'

class DurationTest < Test::Unit::TestCase

  context "A class which has included Pacecar" do
    setup do
      @class = User
    end
    context "with duration methods" do
      setup do
        @days = 14
      end
      should "set the correct expected values for a with_duration_of datetime column method" do
        expected =<<-SQL
        SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (datediff(#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "created_at"}, #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "updated_at"}) = #{@days})
        SQL
        assert_equal expected.strip, @class.with_duration_of(@days, :created_at, :updated_at).to_sql
      end
      should "set the correct expected values for a with_duration_over datetime column method" do
        expected =<<-SQL
        SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (datediff(#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "created_at"}, #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "updated_at"}) > #{@days})
        SQL
        assert_equal expected.strip, @class.with_duration_over(@days, :created_at, :updated_at).to_sql
      end
      should "set the correct expected values for a with_duration_under datetime column method" do
        expected =<<-SQL
        SELECT #{@class.quoted_table_name}.* FROM #{@class.quoted_table_name} WHERE (datediff(#{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "created_at"}, #{@class.quoted_table_name}.#{ActiveRecord::Base.connection.quote_column_name "updated_at"}) < #{@days})
        SQL
        assert_equal expected.strip, @class.with_duration_under(@days, :created_at, :updated_at).to_sql
      end
    end
  end

end

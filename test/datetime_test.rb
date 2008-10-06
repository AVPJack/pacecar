require File.join(File.dirname(__FILE__), 'test_helper')

class DatetimeTest < Test::Unit::TestCase

  context "A class which has included Pacecar" do
    setup do
      @class = User
    end
    context "with before and after methods" do
      setup do
        @time = 5.days.ago
      end
      should "respond to _before datetime column method" do
        assert @class.respond_to? :created_at_before
      end
      should "set correct proxy options for _before datetime column method" do
        proxy_options = { :conditions => ['created_at < ?', @time] }
        assert_equal proxy_options, @class.created_at_before(@time).proxy_options
      end
      should "respond to _after datetime column method" do
        assert @class.respond_to? :created_at_after
      end
      should "set correct proxy options for after_ datetime column method" do
        proxy_options = { :conditions => ['created_at > ?', @time] }
        assert_equal proxy_options, @class.created_at_after(@time).proxy_options
      end
    end
    context "with in_past and in_future methods" do
      setup do
        @now = Time.now
        Time.stubs(:now).returns @now
      end
      should "respond to _in_past datetime column method" do
        assert @class.respond_to? :created_at_in_past
      end
      should "set correct proxy options for _in_past datetime column method" do
        proxy_options = { :conditions => ['created_at < ?', @now] }
        assert_equal proxy_options, @class.created_at_in_past.proxy_options
      end
      should "respond to _in_future datetime column method" do
        assert @class.respond_to? :created_at_in_future
      end
      should "set correct proxy options for _in_future datetime column method" do
        proxy_options = { :conditions => ['created_at > ?', @now] }
        assert_equal proxy_options, @class.created_at_in_future.proxy_options
      end
    end
    context "with _inside and _outside methods" do
      setup do
        @start = 3.days.ago
        @stop = 2.days.ago
      end
      should "respond to _inside datetime column method" do
        assert @class.respond_to? :created_at_inside
      end
      should "set correct proxy options for _inside datetime column method" do
        proxy_options = { :conditions => ['created_at > ? and created_at < ?', @start, @stop] }
        assert_equal proxy_options, @class.created_at_inside(@start, @stop).proxy_options
      end
      should "respond to _outside datetime column method" do
        assert @class.respond_to? :created_at_outside
      end
      should "set correct proxy options for _in_future datetime column method" do
        proxy_options = { :conditions => ['created_at < ? and created_at > ?', @start, @stop] }
        assert_equal proxy_options, @class.created_at_outside(@start, @stop).proxy_options
      end
    end
    context "with year month and day methods" do
      setup do
        @year = '2000'
        @month = '01'
        @day = '01'
      end
      should "respond to _in_year datetime column method" do
        assert @class.respond_to? :created_at_in_year
      end
      should "set correct proxy options for _in_year datetime column method" do
        proxy_options = { :conditions => ['year(created_at) = ?', @year] }
        assert_equal proxy_options, @class.created_at_in_year(@year).proxy_options
      end
      should "respond to _in_month datetime column method" do
        assert @class.respond_to? :created_at_in_month
      end
      should "set correct proxy options for _in_month datetime column method" do
        proxy_options = { :conditions => ['month(created_at) = ?', @month] }
        assert_equal proxy_options, @class.created_at_in_month(@month).proxy_options
      end
      should "respond to _in_day datetime column method" do
        assert @class.respond_to? :created_at_in_day
      end
      should "set correct proxy options for _in_day datetime column method" do
        proxy_options = { :conditions => ['day(created_at) = ?', @day] }
        assert_equal proxy_options, @class.created_at_in_day(@day).proxy_options
      end
    end
    context "with duration methods" do
      setup do
        @days = 14
      end
      should "respond to duration_between datetime column method" do
        assert @class.respond_to? :duration_between
      end
      should "set correct proxy options for duration_between datetime column method" do
        proxy_options = { :select => 'datediff(created_at, updated_at) as duration' }
        assert_equal proxy_options, @class.duration_between(:created_at, :updated_at).proxy_options
      end
      should "set correct proxy options for with_duration_of datetime column method" do
        proxy_options = { :conditions => ['duration = ?', @days] }
        assert_equal proxy_options, @class.with_duration_of(@days).proxy_options
      end
      should "set correct proxy options for with_duration_over datetime column method" do
        proxy_options = { :conditions => ['duration >= ?', @days] }
        assert_equal proxy_options, @class.with_duration_over(@days).proxy_options
      end
      should "set correct proxy options for with_duration_under datetime column method" do
        proxy_options = { :conditions => ['duration <= ?', @days] }
        assert_equal proxy_options, @class.with_duration_under(@days).proxy_options
      end
    end
  end

end

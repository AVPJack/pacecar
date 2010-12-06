module Pacecar
  module Datetime
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def self.extended(base)
        base.send :define_datetime_scopes
      end

      protected

      def define_datetime_scopes
        datetime_column_names.each do |name|
          define_before_after_scopes(name)
          define_past_future_scopes(name)
          define_inside_outside_scopes(name)
          define_in_date_scopes(name)
        end
      end

      def define_before_after_scopes(name)
        scope "#{name}_before".to_sym, lambda { |time|
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} <= ?", time] }
        }
        scope "#{name}_after".to_sym, lambda { |time|
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} >= ?", time] }
        }
      end

      def define_past_future_scopes(name)
        scope "#{name}_in_past", lambda {
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} <= ?", now] }
        }
        scope "#{name}_in_future", lambda {
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} >= ?", now] }
        }
      end

      def define_inside_outside_scopes(name)
        scope "#{name}_inside".to_sym, lambda { |start, stop|
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} >= ? and #{quoted_table_name}.#{connection.quote_column_name name} <= ?", start, stop] }
        }
        scope "#{name}_outside".to_sym, lambda { |start, stop|
          { :conditions => ["#{quoted_table_name}.#{connection.quote_column_name name} <= ? or #{quoted_table_name}.#{connection.quote_column_name name} >= ?", start, stop] }
        }
      end

      def define_in_date_scopes(name)
        case connection.adapter_name
        when 'MySQL', 'Mysql2'
          scope "#{name}_in_year".to_sym, lambda { |year|
            { :conditions => ["year(#{quoted_table_name}.#{connection.quote_column_name name}) = ?", year.to_i] }
          }
          scope "#{name}_in_month".to_sym, lambda { |month|
            { :conditions => ["month(#{quoted_table_name}.#{connection.quote_column_name name}) = ?", month.to_i] }
          }
          scope "#{name}_in_day".to_sym, lambda { |day|
            { :conditions => ["day(#{quoted_table_name}.#{connection.quote_column_name name}) = ?", day.to_i] }
          }
        when 'PostgreSQL'
          scope "#{name}_in_year".to_sym, lambda { |year|
            { :conditions => ["extract(year from #{quoted_table_name}.#{connection.quote_column_name name}) = ?", year.to_i] }
          }
          scope "#{name}_in_month".to_sym, lambda { |month|
            { :conditions => ["extract(month from #{quoted_table_name}.#{connection.quote_column_name name}) = ?", month.to_i] }
          }
          scope "#{name}_in_day".to_sym, lambda { |day|
            { :conditions => ["extract(day from #{quoted_table_name}.#{connection.quote_column_name name}) = ?", day.to_i] }
          }
        when 'SQLite'
          scope "#{name}_in_year".to_sym, lambda { |year|
            { :conditions => ["strftime('%Y', #{quoted_table_name}.#{connection.quote_column_name name}) = ?", sprintf('%04d', year)] }
          }
          scope "#{name}_in_month".to_sym, lambda { |month|
            { :conditions => ["strftime('%m', #{quoted_table_name}.#{connection.quote_column_name name}) = ?", sprintf('%02d', month)] }
          }
          scope "#{name}_in_day".to_sym, lambda { |day|
            { :conditions => ["strftime('%d', #{quoted_table_name}.#{connection.quote_column_name name}) = ?", sprintf('%02d', day)] }
          }
        end
      end

      def now
        defined?(Time.zone_default) && Time.zone_default ? Time.zone_default.now : Time.now
      end

    end
  end
end

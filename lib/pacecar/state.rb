module Pacecar
  module State
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def self.extended(base)
        base.send :define_state_scopes
      end

      protected

      def define_state_scopes
        state_column_names.each do |name|
          const_get(name.pluralize.upcase).each do |state|
            named_scope "#{name}_#{state.downcase}".to_sym, :conditions => ["#{name} = ?", state]
          end
        end
      end

      def state_column_names
        column_names.select { |name| name =~ /_state/ && local_constants.include?(name.pluralize.upcase) }
      end

    end
  end
end

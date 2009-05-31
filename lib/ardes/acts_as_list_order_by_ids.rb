module Ardes #:nodoc:
  # when acts_as_list specified, class methods
  #
  #  * order_by_ids
  #  * order!
  #
  # are appended to the class (and thus any ordered associations as well)
  module ActsAsListOrderByIds
    def self.included(base)
      base.class_eval do
        class<<self
          def acts_as_list_with_order_by_ids(*args, &block)
            returning acts_as_list_without_order_by_ids(*args, &block) do
              cattr_accessor :acts_as_list_column
              options = args.extract_options!
              self.acts_as_list_column = options[:column] || 'position'
              extend ClassMethods
            end
          end
          alias_method_chain :acts_as_list, :order_by_ids
        end
      end
    end
    
    module ClassMethods
      # Order the collection by ids
      def order_by_ids(ids)
        transaction do
          ids.each_index do |i|
            record = find(ids[i])
            record.send("#{acts_as_list_column}=", i+1)
            record.save(false)
          end
        end
      end

      # Order the collection by records or ids
      def order!(*records)
        order_by_ids(records.flatten.map(&:id))
      end
    end
  end
end

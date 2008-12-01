module Ardes #:nodoc:
  # when acts_as_list specified, a class method order_by_ids is appended to the
  # class
  module ActsAsListOrderByIds
    def self.included(base)
      base.class_eval do
        class<<self
          def acts_as_list_with_order_by_ids(*args, &block)
            returning acts_as_list_without_order_by_ids(*args, &block) do 
              options = args.extract_options!
              column = options[:column] || 'position'
              module_eval <<-end_eval, __FILE__, __LINE__
                def self.order_by_ids(ids)
                  transaction do
                    ids.each_index do |i|
                      record = find(ids[i])
                      record.#{column} = i+1
                      record.save(false)
                    end
                  end
                end
              end_eval
            end
          end
          alias_method_chain :acts_as_list, :order_by_ids
        end
      end
    end
  end
end

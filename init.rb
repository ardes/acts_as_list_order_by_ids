begin
  require 'acts_as_list'
rescue LoadError
end

if ActiveRecord::Base.respond_to?(:acts_as_list)
  require 'ardes/acts_as_list_order_by_ids'
  ActiveRecord::Base.send :include, Ardes::ActsAsListOrderByIds
else
  puts "Install acts_as_list via gem or plugin to use acts_as_list_order_by_ids"
end
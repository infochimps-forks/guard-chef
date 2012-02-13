class DataBagJob < Guard::Chef::Base

  def command
    "rake databag:upload['#{name}']"
  end

  def sentinel_re
    /Updated data_bag_item/
  end

  def self.accepts?(path, extension)
    extension.nil? && path =~ /(rb|json)$/
  end

end

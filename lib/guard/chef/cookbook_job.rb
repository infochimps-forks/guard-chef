class CookbookJob < Guard::Chef::Base

  def command
    "knife cookbook upload '#{name}'"
  end

  def sentinel_re
    /upload complete/
  end

end

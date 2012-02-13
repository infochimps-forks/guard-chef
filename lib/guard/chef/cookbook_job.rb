class CookbookJob < Guard::Chef::Base

  def command
    "knife cookbook upload -VV '#{name}'"
  end

  def sentinel_re
    /upload complete/
  end

end

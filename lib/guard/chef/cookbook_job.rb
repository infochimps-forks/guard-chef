class CookbookJob < Guard::Chef::Base

  def command
    "knife cookbook upload -VV '#{name}'"
  end

  def sentinel_re
    /(?:upload complete|uploaded \d+ cookbook)/i
  end

end

class RoleJob < Guard::Chef::Base

  def command
    "knife role from file -VV '#{target}'"
  end

  def sentinel_re
    /Updated Role #{name}!/
  end

  def self.accepts?(path, extension)
    !! (extension =~ /(rb|json)/)
  end

end

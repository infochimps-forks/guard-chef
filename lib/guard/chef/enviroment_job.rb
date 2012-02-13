class EnvironmentJob < Guard::Chef::Base

  def command
    "knife environment from file -VV '#{target}'"
  end

  def sentinel_re
    /Updated Environment #{name}/
  end

  def self.accepts?(path, extension)
    !! (extension =~ /(rb|json)/)
  end

end

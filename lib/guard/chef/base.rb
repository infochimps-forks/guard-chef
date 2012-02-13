class Guard::Chef::Base
  attr_reader :target, :name
  
  def initialize(target, name)
    @target, @name = target, name
  end

  def self.accepts?(path, extension)
    true
  end

  def kind
    self.class.to_s.gsub(/Job/, '').downcase
  end

  def update
    puts "uploading changed #{kind} '#{target}'. Please wait."
    output = `#{command}`
    if output =~ sentinel_re
      puts "#{kind} '#{name}' uploaded."
      true
    else
      puts "#{kind} '#{name}' could not be uploaded."
      false
    end
  end
end

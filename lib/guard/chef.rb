require 'guard'
require 'guard/guard'

module Guard
  class Chef < Guard

    require 'guard/chef/base'
    Dir[File.expand_path('../chef/*_job.rb',  __FILE__)].each {|f| require f}

    def initialize(watchers=[], options={})
      super
      @base_dir = ::File.expand_path('../../../',  __FILE__)
      # init stuff here, thx!
    end

    # =================
    # = Guard methods =
    # =================

    # If one of those methods raise an exception, the Guard::GuardName instance
    # will be removed from the active guards.

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      true
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      true
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      true
    end

    # Called on Ctrl-/ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      true
    end

    # Called on file modifications and additions
    def run_on_changes(paths)
      paths.each do |path|
        unless updated?(path)
          return false
        end
      end
      true
    end

    # warn a user that we don't do anything to handle deleted files.
    # does not call super, so guard action isn't triggered
    def run_on_removals(paths)
      paths.each do |path|
        warn "file #{path} removed -- it's up to you to remove it from the server if desired"
      end
    end

  private

    def updated?(path)
      target = perform(path) or return false
      target.update
      true
    end

    # cookbooks is last because it is most likely to be in a confounding container dir
    CHEF_OBJECT_RE = %r{.*(roles|data_?bags|environments|cookbooks)/([^/]+)}

    # finds
    #    site-cookbooks/flume/recipes/default.rb # => ["cookbooks", "flume" ]
    #    alices-cookbooks/cookbooks/bob/templates/default/charlie.rb # => ["cookbooks", "bob" ]
    def split_path(path)
      m = CHEF_OBJECT_RE.match(path)
      unless m
        warn "Skipping '#{path}' -- it doesn't look like '*cookbooks/**/*', '*roles/*.{rb,json}', '*environments/*.{rb,json}' or '*data_bags/*.{rb,json}'"
        return
      else
        parent_seg, child_seg = m.captures
        child_seg.gsub!(/\.(rb|json)$/, "")
        extension = $1
        [parent_seg, child_seg, extension]
      end
    end

    def jobklass_for(parent_seg)
      case parent_seg
      when /cookbooks/    then CookbookJob
      when /roles/        then RoleJob
      when /data_?bags/   then DataBagJob
      when /environments/ then EnvironmentJob
      else nil
      end
    end

    def perform(path)
      parent_seg, target_name, extension = split_path(path)
      jobklass    = jobklass_for(parent_seg)
      return unless parent_seg && target_name && jobklass
      return unless jobklass.accepts?(path, extension)
      jobklass.new(path, target_name)
    end
  end
end

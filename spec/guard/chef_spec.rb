# encoding: utf-8
require 'spec_helper'

describe Guard::Chef do
  subject { @chef_guard = Guard::Chef.new }

  before(:each) do
    @base_dir = ::File.expand_path('../../../spec/support/chef-repo/',  __FILE__)
  end

  describe "private methods" do
    describe "updated?(path)" do
      it "returns false if perform fails" do
        subject.stub(:perform){ nil }
        subject.send(:updated?, "cookbooks/something/metadata.rb").should be(false)
      end

      it "returns true if perform succeeds" do
        job = mock
        subject.stub(:perform){ job }
        job.stub(:update){ true }
        subject.send(:updated?, "cookbooks/test/metadata.rb").should be(true)
      end
    end

    describe "perform(path)" do
      it "returns nil if the path does not match a type" do
        nostderr{ subject.send(:perform, "badpath/test/metadata.rb").should be_nil }
      end

      it "returns a job object if it matches a type" do
        fn = "cookbooks/test/metadata.rb"
        bob = mock()
        CookbookJob.should_receive(:new).with(fn, "test").and_return(bob)
        subject.send(:perform, "cookbooks/test/metadata.rb").should == bob
      end

      [
        ["alices_cookbooks/site-cookbooks/lunch/recipes/default.rb",    CookbookJob,    "lunch",        nil],
        ["alices_cookbooks/cookbooks/lunch/templates/default/roles.rb", CookbookJob,    "lunch",        nil],
        ["alices_cookbooks/cookbooks/lunch/README.md",                  CookbookJob,    "lunch",        nil],
        ["alices_cookbooks/cookbooks/README.md",                        CookbookJob,    "README.md",    nil],
        ["roles/lunch_master.rb",                                       RoleJob,        "lunch_master", "rb"],
        ["alices_cookbooks/roles/lunch_master.rb",                      RoleJob,        "lunch_master", "rb"],
        ["roles/lunch_master.json",                                     RoleJob,        "lunch_master", "json"],
        ["alices_cookbooks/roles/lunch_master.json",                    RoleJob,        "lunch_master", "json"],
        ["data_bags/lunch/master.rb",                                   DataBagJob,     "lunch",        "rb"],
        ["alices_cookbooks/data_bags/lunch/master.rb",                  DataBagJob,     "lunch",        "rb"],
        ["data_bags/lunch/master.json",                                 DataBagJob,     "lunch",        "json"],
        ["alices_cookbooks/data_bags/lunch/master.json",                DataBagJob,     "lunch",        "json"],
        ["environments/lunch_master.rb",                                EnvironmentJob, "lunch_master", "rb"],
        ["alices_cookbooks/environments/lunch_master.rb",               EnvironmentJob, "lunch_master", "rb"],
        ["environments/lunch_master.json",                              EnvironmentJob, "lunch_master", "json"],
        ["alices_cookbooks/environments/lunch_master.json",             EnvironmentJob, "lunch_master", "json"],
      ].each do |path, jobklass, target_name, extension|
        it("finds %-15s %-12s %-4s for %s" % [jobklass, target_name, extension, path]) do
          bob = mock()
          jobklass.should_receive(:new).with(path, target_name).and_return(bob)
          subject.send(:perform, path).should == bob
        end
      end

      [
        "alices_cookbooks",
        "cookbooks-site/lunch/recipes/default.rb",
        "whatever/lunch/recipes",
        "whatever/roles.rb",
        "roles/README.md",
        "data_bags/README.md",
        "data_bags/something/README.md",
        "data_bags/foo.json",
        "data_bags/foo.rb",
        "environments/README.md",
      ].each do |path|
        it "skips processing files like #{path}" do
          nostderr{ subject.send(:perform, path).should be_nil }
        end
      end

    end
  end

  context 'start' do
    # noop
  end

  context 'reload' do
    # noop
  end

  context 'run_all' do
    # noop
  end

  context 'run_on_change' do
    it "should return true if updated?" do
      subject.stub(:updated?) { true }
      subject.send(:run_on_changes, ["some/resource/path"]).should be(true)
    end

    it "should return false unless updated?" do
      subject.stub(:updated?) { false }
      subject.send(:run_on_changes, ["some/resource/path"]).should be(false)
    end

  end

end

# encoding: utf-8
require 'spec_helper'

describe CookbookJob do
  subject { @job = CookbookJob.new("cookbooks/test/recipes/file.rb", "test") }

  describe "update" do

    it "runs a properly quoted +knife cookbook upload+ command" do
      subject.should_receive(:"`").
        with("knife cookbook upload 'test'").
        and_return( "upload complete" )

      nostdout{ subject.send(:update) }
    end

    it "should be true if it receives the 'upload complete' message" do
      subject.stub(:"`").and_return( "upload complete" )
      nostdout{ subject.send(:update).should be(true) }
    end

    it "should be false if it receives the 'upload complete' message" do
      subject.stub(:"`").and_return( "ZOMG BEES!!!" )
      nostdout{ subject.send(:update).should be(false) }
    end

  end
end

# encoding: utf-8
require 'spec_helper'

describe EnvironmentJob do
  subject { @job = EnvironmentJob.new("environments/happy_environment.json", "happiness") }

  ENVIRONMENT_SUCCESS_MANTRA = "Updated Environment happiness!"

  describe "update" do

    it "runs a properly quoted +knife environment upload+ command" do
      subject.should_receive(:"`").
        with("knife environment from file 'environments/happy_environment.json'").
        and_return( ENVIRONMENT_SUCCESS_MANTRA )

      nostdout{ subject.send(:update) }
    end

    it "is true if it receives the '#{ENVIRONMENT_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ ENVIRONMENT_SUCCESS_MANTRA }
      nostdout{ subject.send(:update).should == true }
    end

    it "is false if it does not receive the '#{ENVIRONMENT_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ "ZOMG BEES!!!" }
      nostdout{ subject.send(:update).should == false }
    end

  end
end

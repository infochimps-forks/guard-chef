# encoding: utf-8
require 'spec_helper'

describe RoleJob do
  subject { @job = RoleJob.new("roles/happy_role.json", "happiness") }

  ROLE_SUCCESS_MANTRA = "Updated Role happiness!"

  describe "update" do

    it "runs a properly quoted +knife role upload+ command" do
      subject.should_receive(:"`").
        with("knife role from file 'roles/happy_role.json'").
        and_return( ROLE_SUCCESS_MANTRA )

      nostdout{ subject.send(:update) }
    end

    it "is true if it receives the '#{ROLE_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ ROLE_SUCCESS_MANTRA }
      nostdout{ subject.send(:update).should == true }
    end

    it "is false if it does not receive the '#{ROLE_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ "ZOMG BEES!!!" }
      nostdout{ subject.send(:update).should == false }
    end

  end
end

# encoding: utf-8
require 'spec_helper'

describe DataBagJob do
  subject { @job = DataBagJob.new("data_bags/something/happy_item.json", "happiness") }

  DATA_BAG_SUCCESS_MANTRA = "Updated data_bag_item"

  describe "update" do

    it "runs a properly quoted +knife data_bag upload+ command" do
      subject.should_receive(:"`").
        with("rake databag:upload['happiness']").
        and_return( DATA_BAG_SUCCESS_MANTRA )

      nostdout{ subject.send(:update) }
    end

    it "is true if it receives the '#{DATA_BAG_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ DATA_BAG_SUCCESS_MANTRA }
      nostdout{ subject.send(:update).should == true }
    end

    it "is false if it does not receive the '#{DATA_BAG_SUCCESS_MANTRA}' message" do
      subject.stub(:"`"){ "ZOMG BEES!!!" }
      nostdout{ subject.send(:update).should == false }
    end

  end
end

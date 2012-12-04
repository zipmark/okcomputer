require 'spec_helper'

describe OKComputer do
  it "exists" do
    OKComputer.should be_a Module
  end

  context "#register(check_name, check_object)" do
    let(:check_name) { :foo }
    let(:check) { stub(:checker_object) }

    it "adds the given check" do
      OKComputer::Checks.should_receive(:register).with(check_name, check)
      OKComputer.register check_name, check
    end
  end
end

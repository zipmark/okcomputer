require "spec_helper"

module OKComputer
  describe Checks do
    context ".registered_checks" do
      let(:no_checks) { nil }
      let(:some_checks) { {foo: "bar"} }

      it "returns an empty list if not set" do
        Checks.send(:registered_checks=, no_checks)
        Checks.registered_checks.should == []
      end

      it "remembers the checks given to it" do
        Checks.send(:registered_checks=, some_checks)
        Checks.registered_checks.should == some_checks.values
      end
    end

    context ".registered_check(check_name)" do
      let(:check_name) { :foo }
      let(:foo_check) { stub(:checker) }

      it "returns the check registered with the given name" do
        Checks.send(:registered_checks=, {check_name => foo_check})
        Checks.registered_check(check_name).should == foo_check
      end

      it "raises an exceiption if given a check that's not registered" do
        Checks.send(:registered_checks=, {})
        expect { Checks.registered_check(check_name) }.to raise_error(Checks::CheckNotFound)
      end
    end
  end
end


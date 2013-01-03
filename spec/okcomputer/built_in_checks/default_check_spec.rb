require "spec_helper"

module OKComputer
  describe DefaultCheck do
    it "is a subclass of Check" do
      subject.should be_a Check
    end

    context "#check" do
      it "simply outputs a string to render" do
        subject.check
        subject.message.should include "OKComputer Site Check Passed"
        subject.should be_success
      end
    end
  end
end

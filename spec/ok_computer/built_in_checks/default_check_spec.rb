require "rails_helper"

module OkComputer
  describe DefaultCheck do
    it "is a subclass of Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      it { is_expected.to be_successful }
      it { is_expected.to have_message "Application is running" }
    end
  end
end

require "rails_helper"

module OkComputer
  describe RubyVersionCheck do
    it "is a subclass of Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      it { is_expected.to be_successful }
      it { is_expected.to have_message "Ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}" }
    end
  end
end

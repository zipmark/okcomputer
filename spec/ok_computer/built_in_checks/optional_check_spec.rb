require "rails_helper"

module OkComputer
  describe OptionalCheck do
    let(:check) { OkComputer::DefaultCheck.new }

    subject { described_class.new(check) }

    context '#success?' do
      before do
        check.mark_failure
      end

      it { is_expected.to be_successful }

      it "has a failure message" do
        expect(subject.to_text).to match /FAILED/
      end
    end

    context '#to_text' do
      before do
        check.registrant_name = "foo"
        check.message = "message"
        expect(check).not_to receive(:call)
        check.mark_failure
      end

      it "combines the upstream data with an optional flag" do
        expect(subject.to_text).to eq "#{check.to_text} (OPTIONAL)"
      end
    end
  end
end

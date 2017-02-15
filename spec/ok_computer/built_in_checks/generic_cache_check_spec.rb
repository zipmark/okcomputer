require "rails_helper"

module OkComputer
  describe GenericCacheCheck do
    it "is a Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      let(:value) { "asdf" }
      let(:incorrect_value) { "qwerty" }
      let(:error) { StandardError.new("connection failure") }

      context "with a successful connection" do
        before do
          expect(subject).to receive(:test_value).and_return(value)
          expect(Rails.cache).to receive(:write)
          expect(Rails.cache).to receive(:read).and_return(value)
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Able to read and write via File store" }
      end

      context "with a failed write" do
        before do
          expect(subject).to receive(:test_value).and_return(value)
          expect(Rails.cache).to receive(:write).and_raise(error)
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Connection failure: #{error}" }
      end

      context "with a failed read" do
        before do
          expect(subject).to receive(:test_value).and_return(value)
          expect(Rails.cache).to receive(:write)
          expect(Rails.cache).to receive(:read).and_raise(error)
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Connection failure: #{error}" }
      end

      context "with a mismatched result from the read" do
        before do
          expect(subject).to receive(:test_value).and_return(value)
          expect(Rails.cache).to receive(:write)
          expect(Rails.cache).to receive(:read).and_return(incorrect_value)
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Value read from the cache does not match the value written" }
      end
    end
  end
end

require "rails_helper"

module OkComputer
  describe ActiveRecordCheck do
    it "is a subclass of Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      let(:version) { "20121205" }
      let(:error_message) { "Error message" }

      context "with a successful connection" do
        before do
          expect(subject).to receive(:schema_version) { version }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Schema version: #{version}" }
      end

      context "with an unsuccessful connection" do
        before do
          expect(subject).to receive(:schema_version).and_raise(ActiveRecordCheck::ConnectionFailed, error_message)
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Error: '#{error_message}'" }
      end
    end

    context "#version" do
      let(:result) { "123" }
      let(:error_message) { "Wrong password" }

      it "queries from ActiveRecord its installed schema" do
        expect(ActiveRecord::Migrator).to receive(:current_version) { result }
        expect(subject.schema_version).to eq(result)
      end

      it "raises ConnectionFailed in the event of any error" do
        expect(ActiveRecord::Migrator).to receive(:current_version).and_raise(StandardError, error_message)
        expect { subject.schema_version }.to raise_error(ActiveRecordCheck::ConnectionFailed, error_message)
      end
    end
  end
end

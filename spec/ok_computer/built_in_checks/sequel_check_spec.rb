require "rails_helper"
require 'sequel'

module OkComputer
  describe SequelCheck do
    it "is a subclass of Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      let(:error_message) { "Error message" }

      context "with a successful connection" do
        before do
          expect(subject).to receive(:is_current?) { true }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Schema is up to date" }
      end

      context "with an unsuccessful connection" do
        before do
          expect(subject).to receive(:is_current?).and_raise(SequelCheck::ConnectionFailed, error_message)
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Error: '#{error_message}'" }
      end
    end

    context "#is_current?" do
      let(:result) { true }
      let(:error_message) { "Wrong password" }

      around do |example|
        Sequel.extension(:migration)
        db = Sequel.connect(adapter: 'sqlite', database: ':memory:')
        example.run
        db.disconnect
      end

      it "queries from Sequel its installed schema" do
        expect(Sequel::Migrator).to receive(:is_current?) { result }
        expect(subject.is_current?).to eq(result)
      end

      it "raises ConnectionFailed in the event of any error" do
        expect(Sequel::Migrator).to receive(:is_current?).and_raise(StandardError, error_message)
        expect { subject.is_current? }.to raise_error(SequelCheck::ConnectionFailed, error_message)
      end
    end
  end
end

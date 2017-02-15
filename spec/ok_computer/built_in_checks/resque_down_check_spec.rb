require "rails_helper"

# Stubbing the constant out; will exist in apps which have Resque loaded
class Resque; end

module OkComputer
  describe ResqueDownCheck do
    it "is a Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      context "when not queued" do
        before do
          allow(subject).to receive(:queued?) { false }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Resque is working" }
      end

      context "when queued" do
        before do
          allow(subject).to receive(:queued?) { true }
        end

        context "with workers working" do
          before do
            allow(subject).to receive(:working?) { true }
          end

          it { is_expected.to be_successful }
          it { is_expected.to have_message "Resque is working" }
        end

        context "with workers not working" do
          before do
            allow(subject).to receive(:working?) { false }
          end

          it { is_expected.not_to be_successful }
          it { is_expected.to have_message "Resque is DOWN" }
        end
      end
    end

    context "#queued?" do
      it "is true if Resque says the queue has jobs" do
        expect(Resque).to receive(:info) { {pending: 11} }
        expect(subject).to be_queued
      end

      it "is false if Resque says the queue has no jobs" do
        expect(Resque).to receive(:info) { {pending: 0} }
        expect(subject).not_to be_queued
      end
    end

    context "#working?" do
      it "is true if Resque says it has workers working" do
        expect(Resque).to receive(:info) { {working: 1} }
        expect(subject).to be_working
      end

      it "is false if Resque says its jobs are not working" do
        expect(Resque).to receive(:info) { {working: 0} }
        expect(subject).not_to be_working
      end
    end
  end
end

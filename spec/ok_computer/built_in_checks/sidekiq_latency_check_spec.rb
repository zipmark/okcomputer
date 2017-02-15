require "rails_helper"

# Stubbing the constant out; will exist in apps which have Sidekiq loaded
module Sidekiq
  class Queue
    def initialize(queue)
    end
  end
end

module OkComputer
  describe ResqueBackedUpCheck do
    let(:queue) { "queue name" }
    let(:threshold) { 30 }

    subject { SidekiqLatencyCheck.new queue, threshold }

    it "is a Check" do
      expect(subject).to be_a Check
    end

    context ".new(queue, threshold)" do
      it "accepts a queue name and a latency threshold to consider backed up" do
        expect(subject.queue).to eq(queue)
        expect(subject.threshold).to eq(threshold)
      end

      it "coerces the threshold parameter into an integer" do
        threshold = "30"
        expect(described_class.new(queue, threshold).threshold).to eq(30)
      end
    end

    context "#check" do
      let(:status) { "status text" }

      context "with the count less than the threshold" do
        before do
          allow(subject).to receive(:size) { threshold - 1 }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Sidekiq queue '#{queue}' latency at reasonable level (#{subject.size})" }
      end

      context "with the count equal to the threshold" do
        before do
          allow(subject).to receive(:size) { threshold }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Sidekiq queue '#{queue}' latency at reasonable level (#{subject.size})" }
      end

      context "with a count greater than the threshold" do
        before do
          allow(subject).to receive(:size) { threshold + 1 }
        end

        it { is_expected.not_to be_successful }
        it { is_expected.to have_message "Sidekiq queue '#{queue}' latency is #{subject.size - subject.threshold} over threshold! (#{subject.size})" }
      end
    end

    context "#size" do
      let(:size) { 30 }
      let(:sidekiq_queue) { double(queue) }

      before do
        allow(Sidekiq::Queue).to receive(:new) { sidekiq_queue }
      end

      it "defers to Sidekiq for the job count" do
        expect(sidekiq_queue).to receive(:latency) { size }
        expect(subject.size).to eq(size)
      end
    end
  end
end

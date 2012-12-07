require "spec_helper"

# Stubbing the constant out; will exist in apps which have Resque loaded
class Resque; end

module OKComputer
  describe ResqueBackedUpCheck do
    let(:queue) { "queue name" }
    let(:threshold) { 100 }

    subject { ResqueBackedUpCheck.new queue, threshold }

    it "is a Check" do
      subject.should be_a Check
    end

    context ".new(queue, threshold)" do
      it "accepts a queue name and a threshold to consider backed up" do
        subject.queue.should == queue
        subject.threshold.should == threshold
      end
    end

    context "#call" do
      let(:status) { "status text" }

      it "returns success message if count is less than threshold" do
        subject.stub(:count) { threshold - 1}
        subject.should_not_receive(:mark_failure)
        subject.call.should == "Resque queue '#{queue}' at reasonable level (#{subject.count})"
      end

      it "returns success message if count is equal to threshold" do
        subject.stub(:count) { threshold }
        subject.should_not_receive(:mark_failure)
        subject.call.should == "Resque queue '#{queue}' at reasonable level (#{subject.count})"
      end

      it "returns failure message if count is greater than threshold" do
        subject.stub(:count) { threshold + 1 }
        subject.should_receive(:mark_failure)
        subject.call.should == "Resque queue '#{queue}' backed up! (#{subject.count})"
      end
    end

    context "#count" do
      let(:count) { 123 }

      it "defers to Resque for the job count" do
        Resque.should_receive(:size).with(subject.queue) { count }
        subject.count.should == count
      end
    end
  end
end

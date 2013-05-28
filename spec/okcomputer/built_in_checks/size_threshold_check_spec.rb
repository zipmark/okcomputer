require "spec_helper"

module OKComputer
  describe SizeThresholdCheck do
    let(:size_obj) { (1..99).to_a }
    let(:threshold) { 100 }
    let(:name) { "name" }

    subject { SizeThresholdCheck.new size_obj, threshold, :name => name }

    it "is a Check" do
      subject.should be_a Check
    end

    context ".new(size_obj, threshold, options)" do
      it "accepts a size_obj, a threshold and options to consider if the size object is over the defined threshold" do
        subject.size_obj.should == size_obj
        subject.threshold.should == threshold
        subject.name.should == name
      end

      it "coerces the threshold parameter into an integer" do
        threshold = "123"
        SizeThresholdCheck.new(size_obj, threshold).threshold.should == 123
      end

      it "should raise an Argument Error if size_obj doesn't respond to size" do
        size_obj = Object.new
        lambda { SizeThresholdCheck.new(size_obj, threshold) }.should raise_error(ArgumentError, "Size Object must respond to size")
      end
    end

    context "#name" do
      it "should set it to the passed name option" do
        subject.name.should be name
      end

      context "no name option is passed" do
        let(:name) { nil }

        it "to set the passed name option" do
          subject.name.should_not be name
        end

        it "use the size object's class name" do
          subject.name.should == size_obj.class.to_s
        end
      end
    end

    context "#check" do
      context "with the count less than the threshold" do
        before do
          subject.stub(:size) { threshold - 1 }
        end

        it { should be_successful }
        it { should have_message "#{name} at reasonable level (#{subject.size})" }
      end

      context "with the count equal to the threshold" do
        before do
          subject.stub(:size) { threshold }
        end

        it { should be_successful }
        it { should have_message "#{name} at reasonable level (#{subject.size})" }
      end

      context "with a count greater than the threshold" do
        before do
          subject.stub(:size) { threshold + 1 }
        end

        it { should_not be_successful }
        it { should have_message "#{name} is over #{subject.threshold} threshold! (#{subject.size})" }
      end
    end

    context "#size" do
      let(:size) { 123 }

      it "defer size to the size object" do
        size_obj.should_receive(:size)
        subject.size
      end
    end
  end
end

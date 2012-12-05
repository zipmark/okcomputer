require "spec_helper"

module OKComputer
  describe Check do
    it "has a name attribute which it does not set" do
      subject.name.should be_nil
    end

    context "#perform" do
      it "raises an exception, to be overwritten by subclasses" do
        expect { subject.perform }.to raise_error(Check::PerformNotDefined)
      end
    end

    context "displaying the output of #perform" do
      before do
        subject.name = "foo"
        subject.stub(perform: "Everything is great!")
      end

      context "#to_text" do
        it "combines the name and result of #perform" do
          subject.to_text.should == "#{subject.name}: #{subject.perform}"
        end
      end

      context "#to_json" do
        it "returns JSON with the name as the key and result of perform as the value" do
          subject.to_json.should == {subject.name => subject.perform}.to_json
        end
      end
    end
  end
end

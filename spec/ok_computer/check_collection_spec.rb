require "rails_helper"

module OkComputer
  describe CheckCollection do
    let(:foocheck) { double(:check) }
    let(:barcheck) { double(:check) }
    let(:registry) { {foo: foocheck, bar: barcheck} }

    subject { CheckCollection.new("foo collection name") }

    before do
      allow(foocheck).to receive("collection=")
      allow(barcheck).to receive("collection=")
      subject.register(:foo, foocheck)
      subject.register(:bar, barcheck)
    end

    context ".new" do
      it "sets the display name of the check collection" do
        expect(subject.display).to eq("foo collection name")
      end
    end

    [false, true].each do |check_in_parallel|
      before { OkComputer.check_in_parallel = check_in_parallel }

      context "with check_in_parallel set to #{check_in_parallel}" do
        context "#run" do
          it "runs its registered checks" do
            foocheck.should_receive(:run)
            barcheck.should_receive(:run)
            subject.run
          end
        end
      end
    end

    context "#checks" do
      it "returns the checks from its registry" do
        expect(subject.checks).to eq(registry.values)
      end
    end

    context "#register" do
      it "registers a check" do
        subject.register(:foo, foocheck)
        expect(subject.checks).to include(foocheck)
      end

      it "assigns itself to as a check's collection" do
        expect(foocheck).to receive("collection=").with(subject)
        subject.register(:foo, foocheck)
      end
    end

    context "#deregister" do
      it "deregisters a check" do
        subject.deregister(:foo)
        expect(subject.checks).not_to include(foocheck)
      end
      
      it "removes itself as a check's collection" do
        expect(foocheck).to receive("collection=").with(nil)
        subject.deregister(:foo)
      end
    end
    context "#fetch" do
      #TODO All of these tests
      it "finds checks in the current collection" do

      end

      it "finds checks in a sub_collection" do

      end

      it "finds checks in a sub_collection's sub_collection" do

      end

      it "returns nil if the if the check is not in the collection or a sub_collection" do

      end
      it "finds the check in a sub_collection when the sub_collection is not the first sub_collection" do
        sub_collection_1 = CheckCollection.new("sub1")
        sub_collection_2 = CheckCollection.new("sub2")
        subject.register("sub1", sub_collection_1)
        subject.register("sub2", sub_collection_2)
        sub_collection_2.register("foo_subcheck", foocheck)
        expect(subject.fetch("foo_subcheck")).to eq(foocheck)
      end
    end
    context "#to_text" do
      it "returns the #to_text of each check on a new line" do
        foocheck.stub(:to_text) { "foo" }
        barcheck.stub(:to_text) { "bar" }
        expect(subject.to_text).to eq("foo collection name\n\s\sfoo\n\s\sbar")
      end
    end

    context "#to_json" do
      it "returns the #to_json of each check in a JSON array" do
        foocheck.stub(:to_json) { {"foo" => "foo result"}.to_json }
        barcheck.stub(:to_json) { {"bar" => "bar result"}.to_json }
        combined_hash = JSON.parse(foocheck.to_json).merge(JSON.parse(barcheck.to_json))
        subject.to_json.should == combined_hash.to_json
      end
    end

    context "#success?" do
      it "is true if all checks are true" do
        foocheck.stub(:success?) { true }
        barcheck.stub(:success?) { true }
        subject.should be_success
      end

      it "is failse if any check is false" do
        foocheck.stub(:success?) { true }
        barcheck.stub(:success?) { false }
        subject.should_not be_success
      end
    end
  end
end

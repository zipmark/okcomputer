require "rails_helper"

module OkComputer
  describe Registry do
    let(:check_object) { double(:first_checker, :registrant_name= => nil) }
    let(:collection) { CheckCollection.new('foo collection') }
    before do
      collection.register('foo', Check.new)
      collection.register('bar', Check.new)
      allow(Registry).to receive(:default_collection){ collection }
    end

    context ".all" do

      it "returns a CheckCollection with all of the registered checks" do
        expect(Registry.all).to be_instance_of(CheckCollection)
      end
    end
    context ".fetch(check_name)" do
      let(:check_name) { "foo" }

      it "returns the check registered with the given name" do
        Registry.register(check_name, check_object)
        Registry.fetch(check_name).should == check_object
      end

      it "raises an exceiption if given a check that's not registered" do
        Registry.deregister(check_name)
        expect { Registry.fetch(check_name) }.to raise_error(Registry::CheckNotFound)
      end
    end

    context ".register(check_name, check_object)" do
      let(:check_name) { "foo" }
      let(:second_check_object) { double(:second_checker, :registrant_name= => nil) }
      let(:default_collection) { double }

      before do
        # make sure it isn't there yet
        Registry.deregister(check_name)
      end

      it "assigns the given name to the check" do
        check_object.should_receive(:registrant_name=).with(check_name)
        Registry.register(check_name, check_object)
      end

      it "adds the check to the list of checks" do
        Registry.register(check_name, check_object)
        expect( Registry.registry.fetch(check_name) ).to eq(check_object)
      end

      it "overwrites the current check with the given name" do
        # put the first one in and make sure it's there
        Registry.register(check_name, check_object)
        Registry.registry[check_name].should == check_object

        # put the second one in there, and first one gets replaced
        Registry.register(check_name, second_check_object)
        Registry.registry.values.should_not include check_object
        Registry.registry[check_name].should == second_check_object
      end
      
      it "uses the default collection if you don't pass a collection name" do
        allow(Registry).to receive(:default_collection){ default_collection }
        expect(default_collection).to receive(:register).with(check_name, check_object)
        Registry.register(check_name, check_object)
      end

      it "throws a collection not found error if a collection with the given name is not found" do
        expect { Registry.register(check_name, check_object, "missing collection") }.to raise_error(Registry::CollectionNotFound)
      end

      it "registers the check to the given check collection" do
        collection = CheckCollection.new('test collection')
        Registry.register('test_collection', collection)
        Registry.register(check_name, check_object, 'test_collection')
        expect(collection.fetch(check_name)).to eq(check_object)
      end
    end

    context ".deregister(check_name)" do
      let(:check_name) { "foo" }

      it "removes the checker from the list of checkers" do
        # add it
        Registry.register(check_name, check_object)
        # then remove it
        Registry.deregister(check_name)
        Registry.registry.keys.should_not include check_name
        Registry.registry.values.should_not include check_object
      end

      it "throws a collection not found error if the given collection is not found" do
        expect {  Registry.deregister(check_name, 'missing collection') }.to raise_error(Registry::CollectionNotFound)
      end

      it "deregisters a check from a check collection" do
        collection = CheckCollection.new('test collection')
        Registry.register('test_collection', collection)
        Registry.register(check_name, check_object, 'test_collection')
        expect(collection.fetch(check_name)).to eq(check_object)
        Registry.deregister(check_name, 'test_collection')
        expect(collection.fetch(check_name)).to eq(nil)
      end

      it "does not error if the name isn't registered" do
        Registry.deregister(check_name)
        Registry.deregister(check_name)
      end
    end
  end
end


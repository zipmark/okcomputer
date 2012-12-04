require 'spec_helper'

describe OKComputerController do
  describe "GET 'index'" do
    let(:results) { {foo: "foo result ", bar: "bar result"} }

    before do
      OKComputer.should_receive(:results) { results }
    end

    it "performs the basic up check" do
      get :index, format: :text, use_route: :ok_computer
      response.body.should == results.values.join("\n")
    end

    it "performs the basic up check as JSON" do
      get :index, format: :json, use_route: :ok_computer
      response.body.should == results.to_json
    end

    it "returns a failure status code if any check fails"

    it "returns a success status code if all checks pass"
  end

  describe "GET 'show'" do
    let(:check_type) { :basic }
    let(:result) { "Basic result" }

    before do
      OKComputer.should_receive(:perform_check).with(check_type) { result }
    end

    it "performs the given check and returns text" do
      get :show, check: check_type, format: :text, use_route: :ok_computer
      response.body.should == result
    end

    it "performs the given check and returns JSON" do
      get :show, check: check_type, format: :json, use_route: :ok_computer
      response.body.should == {check_type => result}.to_json
    end

    it "returns a success status code if the check passes"
    it "returns a failure status code if the check fails"
    it "returns a failure status code if given a status check not already registered"
  end
end

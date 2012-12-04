require 'spec_helper'

describe OkComputerController do
  describe "GET 'index'" do
    let(:checker) { stub(:check_wrapper_object)}

    before do
      OKComputer.stub(:checker) { checker }
    end

    it "performs the basic up check" do
      checker.stub(:to_text) { "text of the results" }
      get :index, format: :text
      response.body.should == checker.to_text
    end

    it "performs the basic up check as JSON" do
      checker.stub(:to_json) { "json of the results" }
      get :index, format: :json
      response.body.should == checker.to_json
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
      get :show, check: check_type, format: :text
      response.body.should == result
    end

    it "performs the given check and returns JSON" do
      get :show, check: check_type, format: :json
      response.body.should == {check_type => result}.to_json
    end

    it "returns a success status code if the check passes"
    it "returns a failure status code if the check fails"
    it "returns a failure status code if given a status check not already registered"
  end
end

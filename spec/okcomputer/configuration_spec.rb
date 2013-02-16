require "spec_helper"

describe OKComputer do
  context "#require_authentication" do
    let(:username) { "foo" }
    let(:password) { "bar" }

    it "captures username and password necessary to access OKComputer" do
      OKComputer.require_authentication(username, password)
      OKComputer.username.should == username
      OKComputer.password.should == password
    end
  end
end

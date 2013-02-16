require "spec_helper"

describe OKComputer do
  let(:username) { "foo" }
  let(:password) { "bar" }

  context "#require_authentication" do
    it "captures username and password necessary to access OKComputer" do
      OKComputer.require_authentication(username, password)
      OKComputer.username.should == username
      OKComputer.password.should == password
    end
  end

  context "#requires_authentication?" do
    it "is true if username and password are configured" do
      OKComputer.send(:username=, username)
      OKComputer.send(:password=, password)
      OKComputer.requires_authentication?.should be_true
    end

    it "is false if username and password are not configured" do
      OKComputer.send(:username=, nil)
      OKComputer.send(:password=, nil)
      OKComputer.requires_authentication?.should be_false
    end
  end
end

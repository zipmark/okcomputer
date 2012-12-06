require "spec_helper"

module OKComputer
  describe DatabaseCheck do
    it "is a subclass of Check" do
      subject.should be_a Check
    end

    context "#call" do
      let(:version) { "20121205" }
      let(:error_message) { "Error message" }

      it "confirms connection to the database" do
        subject.should_receive(:schema_version) { version }
        subject.call.should == "Schema version: #{version}"
      end

      it "returns a valid failure message" do
        subject.should_receive(:schema_version).and_raise(DatabaseCheck::ConnectionFailed, error_message)
        subject.call.should == "Failed to connect: '#{error_message}'"
      end
    end

    context "#version" do
      let(:connection) { stub(:connection) }
      let(:result) { "123" }
      let(:error_message) { "Wrong password" }

      before do
        ActiveRecord::Base.should_receive(:connection) { connection }
      end

      it "queries from ActiveRecord its installed schema" do
        connection.should_receive(:select_value).with("SELECT MAX(version) FROM schema_migrations") { result }
        subject.version.should == result
      end

      it "raises ConnectionFailed in the event of any error" do
        connection.should_receive(:select_value).and_raise(StandardError, error_message)
        expect { subject.version }.to raise_error(DatabaseCheck::ConnectionFailed, error_message)
      end
    end
  end
end

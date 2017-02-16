require "rails_helper"

module OkComputer
  describe CacheCheck do

    let(:stats) do
      { "foo" => { "bytes" => "10000000", "limit_maxbytes" => "30000000" },
        "bar" => { "bytes" => "40000", "limit_maxbytes" => "900000" } }
    end

    it "is a Check" do
      expect(subject).to be_a Check
    end

    context "new(host)" do
      it "remembers the host given to it" do
        subject = CacheCheck.new("example.com")
        expect(subject.host).to eq("example.com")
      end

      it "defaults to the machine's name" do
        subject = CacheCheck.new
        expect(subject.host).to eq(Socket.gethostname)
      end
    end

    context "#check" do
      let(:stats) { "foo" }
      let(:error_message) { "Error message" }

      context "with a successful connection" do
        before do
          expect(subject).to receive(:stats) { stats }
        end

        it { is_expected.to be_successful }
        it { is_expected.to have_message "Cache is available (#{stats})" }
      end

      context "with an unsuccessful connection" do
        before do
          expect(subject).to receive(:stats).and_raise(CacheCheck::ConnectionFailed, error_message)
        end

        it {is_expected.not_to be_successful }
        it {is_expected.to have_message "Error: '#{error_message}'" }
      end
    end

    context "#stats" do

      context "when can connect to cache" do
        before do
          stub_const("Socket", Module.new)
          allow(Socket).to receive(:gethostname){ 'foo' }
          allow(Rails).to receive_message_chain(:cache, :stats){ stats }
        end

        it "should return a stats string" do
          expect(subject.stats).to eq "9 / 28 MB, 1 peers"
        end
      end

      context "when cannot connect to cache" do
        before do
          allow(Rails).to receive_message_chain(:cache, :stats){ raise 'broken' }
        end

        it { expect{ subject.stats }.to raise_error(CacheCheck::ConnectionFailed) }
      end

      context "when using a cache without stats" do
        it "should return an empty string" do
          expect(subject.stats).to eq ""
        end
      end
    end
  end
end

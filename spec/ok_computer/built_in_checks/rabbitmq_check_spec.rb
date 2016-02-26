require "rails_helper"

module OkComputer
  describe RabbitmqCheck do
    before do
      ENV['CLOUDAMQP_URL'] = 'amqp://local'

      bunny_stub = Class.new
      bunny_stub.class_eval { def initialize(url); end; def start; end }
      stub_const 'Bunny', bunny_stub

      error_stub = Class.new(StandardError)
      stub_const 'Bunny::TCPConnectionFailedForAllHosts', error_stub
    end

    subject { described_class.new }

    it "is a subclass of Check" do
      subject.should be_a Check
    end

    describe "#check" do
      context "when the connection is successful" do
        context "when the status is OK" do
          before do
            subject.stub(:connection_status).and_return(:open)
          end

          it { should be_successful }
          it { should have_message "Rabbit Connection Status: (open)" }
        end
      end

      context "when the connection fails" do
        let(:error_message) { "could not establish TCP connection to any of the configured hosts" }

        before do
          allow_any_instance_of(Bunny).to receive(:start).and_raise(Bunny::TCPConnectionFailedForAllHosts, error_message)
        end

        it { should_not be_successful }
        it { should have_message "Error: '#{error_message}'" }
      end
    end

    describe '#connection_status' do
      it 'returns a successful status when the connection is successful' do
        allow_any_instance_of(Bunny).to receive(:start)
        allow_any_instance_of(Bunny).to receive(:status).and_return(:open)
        allow_any_instance_of(Bunny).to receive(:close)

        expect(subject.connection_status).to eq(:open)
      end

      it 'raises a ConnectionFailed error when unable to connect' do
        allow_any_instance_of(Bunny).to receive(:start).and_raise(Bunny::TCPConnectionFailedForAllHosts)
        expect { raise subject.connection_status }.to raise_error(StandardError)
      end
    end

  end
end

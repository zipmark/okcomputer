require "rails_helper"

module OkComputer
  describe ActiveRecordMigrationsCheck do
    it "is a subclass of Check" do
      expect(subject).to be_a Check
    end

    context "#check" do
      context "if activerecord supports needs_migration?" do
        before do
          allow(ActiveRecord::Migrator).to receive(:respond_to?).with(:needs_migration?).and_return(true)
        end

        context "with no pending migrations" do
          before do
            expect(ActiveRecord::Migrator).to receive(:needs_migration?).and_return(false)
          end

          it { is_expected.to be_successful }
          it { is_expected.to have_message "NO pending migrations" }
        end

        context "with pending migrations" do
          before do
            expect(ActiveRecord::Migrator).to receive(:needs_migration?).and_return(true)
          end

          it { is_expected.not_to be_successful }
          it { is_expected.to have_message "Pending migrations" }
        end
      end

      context "on older versions of ActiveRecord" do
        before do
          allow(ActiveRecord::Migrator).to receive(:respond_to?).with(:needs_migration?).and_return(false)
        end

        it { is_expected.not_to be_successful }
      end
    end
  end
end

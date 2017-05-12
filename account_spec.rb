require "rspec"

require_relative "account"

describe Account do
  let(:acct_number) {"1234567890"}
  let(:account) { Account.new(acct_number)}

  describe "#initialize" do
    context "with valid input" do
      it "creates a new account" do
        expect(Account.new("1234567890")).to be_a_kind_of(Account)
      end

      it "creates an account with a specific balance if provided" do
        starting_balance = 20
        expect(Account.new("1234567890", starting_balance).balance).to eq starting_balance
      end
    end

    context "with invalid input" do
      it "throws error when not given acct_number argument" do
        expect { Account.new }.to raise_error(ArgumentError)
      end

      it "throws error when acct_number isnot a string" do
        expect { Account.new(12345678910) }.to raise_error(NoMethodError)
      end

      it "throws error when acct_number has more than 10 digits" do
        expect { Account.new("12345678910") }.to raise_error(InvalidAccountNumberError)
      end

      it "throws error when acct_number has less than 10 digits" do
        expect { Account.new("12345678") }.to raise_error(InvalidAccountNumberError)
      end

      it "throws error when acct_number has non-digits" do
        expect { Account.new("a123456789") }.to raise_error(InvalidAccountNumberError)
      end
    end
  end

  describe "#transactions" do
    it "returns the transactions of the account" do
      account.deposit!(20)
      account.withdraw!(5)
      expect(account.transactions).to eq [0, 20, -5]
    end
  end

  describe "#balance" do
    it "returns the sum of all element" do
      account.deposit!(20)
      account.withdraw!(5)
      account.deposit!(10)
      expect(account.balance).to eq 25
    end
  end

  describe "#account_number" do
    it "masks the first 6 numbers" do
      expect(account.acct_number).to eq "******7890"
    end
  end

  describe "deposit!" do
    it "adds to the transaction and have a new added balance" do
      account.deposit! 5
      account.deposit! 10
      expect(account.balance == 15 && account.transactions == [0, 5, 10]).to be true
    end

    it "raises error when it is a negative deposit" do
      expect { account.deposit!(-2) }.to raise_error(NegativeDepositError)
    end
  end

  describe "#withdraw!" do
    it "adds to the transaction and have a new added balance" do
      account.deposit! 20
      account.withdraw! 5
      account.withdraw! 10
      expect(account.balance == 5 && account.transactions == [0, 20, -5, -10]).to be true
    end

    it "raises error when it is an overdraft" do
      expect { account.withdraw!(-20) }.to raise_error(OverdraftError)
    end
  end
end
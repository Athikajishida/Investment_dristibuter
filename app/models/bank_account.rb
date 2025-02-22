# app/models/bank_account.rb
class BankAccount < ApplicationRecord

  # Basic validations for bank account
  validates :name, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Calculate available balance considering minimum balance requirement
  def available_balance
    min_balance_enforced ? balance - min_balance_amount.to_f : balance
  end

  # Main logic for investment distribution
  def self.calculate_investment_distribution(investment_amount)
    return [] if investment_amount <= 0

    # Get all accounts and calculate total available money
    available_accounts = BankAccount.all.to_a
    total_available = available_accounts.sum(&:available_balance)

    # If investment amount is more than total available, return "NO MATCH"
    return "NO MATCH" if investment_amount > total_available
    
    result = []
    remaining_amount = investment_amount
    
    # Try exact match first
    exact_match = available_accounts.find { |acc| acc.available_balance == remaining_amount }
    if exact_match
      return [{account: exact_match, amount: remaining_amount}]
    end
    
    # Try single account with greater balance
    greater_account = available_accounts
      .find { |acc| acc.available_balance > remaining_amount }
    if greater_account
      return [{account: greater_account, amount: remaining_amount}]
    end
    
    # Try combination of accounts
    available_accounts.sort_by(&:available_balance).reverse.each do |account|
      if remaining_amount > 0 && account.available_balance > 0
        amount_to_take = [remaining_amount, account.available_balance].min
        result << {account: account, amount: amount_to_take}
        remaining_amount -= amount_to_take
      end
    end
    
    remaining_amount.zero? ? result : "NO MATCH"
  end
end
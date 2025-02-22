# @file app/models/bank_account.rb
# @description Represents a bank account with validations and business logic
#              for calculating available balance and investment distribution.
#              Includes functionality for handling minimum balance requirements
#              and complex investment distribution strategies.
# @version 1.0.0
# @author
#   - Athika Jishida
#
class BankAccount < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Calculate the available balance of the account.
  # If there's a minimum balance requirement, subtract that amount from the current balance.
  # Otherwise, just return the full balance.
  # @return [Float] The available balance that can be used for investments
  def available_balance
    min_balance_enforced ? balance - min_balance_amount.to_f : balance
  end

  # Distribute an investment amount across available bank accounts.
  # This method implements a sophisticated distribution strategy with the following priorities:
  #
  # 1. Exact Match: Find an account with an available balance that exactly matches
  #    the investment amount.
  # 2. Single Account: Find an account with a balance greater than the investment amount.
  # 3. Multiple Accounts: Distribute across multiple accounts with specific priority:
  #    a. First try to use Account1 if available
  #    b. Then use other accounts in descending balance order
  #
  # @param [Float] investment_amount The amount to be invested/distributed
  #
  # @return [Array<Hash>] An array of hashes, each containing:
  #   - :account (BankAccount) The bank account to draw from
  #   - :amount (Float) The amount to draw from this account
  # @return [String] "NO MATCH" if no valid distribution can be made
  # @return [Array] Empty array if investment_amount is <= 0
  #
  # @raise [ArgumentError] If investment_amount is nil
  def self.calculate_investment_distribution(investment_amount)
    # Return empty array for invalid investment amounts
    return [] if investment_amount <= 0

    # Get all available accounts and calculate total available funds
    available_accounts = BankAccount.all.to_a
    total_available = available_accounts.sum(&:available_balance)

    # Return "NO MATCH" if investment amount exceeds total available funds
    return "NO MATCH" if investment_amount > total_available

    result = []
    remaining_amount = investment_amount

    # Strategy 1: Look for exact match
    exact_match = available_accounts.find { |acc| acc.available_balance == remaining_amount }
    if exact_match
      return [{account: exact_match, amount: remaining_amount}]
    end

    # Strategy 2: Look for single account with greater balance
    greater_account = available_accounts.find { |acc| acc.available_balance > remaining_amount }
    if greater_account
      return [{account: greater_account, amount: remaining_amount}]
    end

    # Strategy 3a: Start with Account1 if possible
    account1 = available_accounts.find { |acc| acc.name == 'Account1' }
    if account1 && account1.available_balance.positive?
      amount_from_acc1 = [remaining_amount, account1.available_balance].min
      result << {account: account1, amount: amount_from_acc1}
      remaining_amount -= amount_from_acc1
    end

    # Strategy 3b: Use other accounts in descending balance order
    if remaining_amount.positive?
      other_accounts = available_accounts
        .reject { |acc| acc.name == 'Account1' }
        .sort_by(&:available_balance)
        .reverse

      other_accounts.each do |account|
        if remaining_amount.positive? && account.available_balance.positive?
          amount_to_take = [remaining_amount, account.available_balance].min
          result << {account: account, amount: amount_to_take}
          remaining_amount -= amount_to_take
        end
      end
    end

    # Return result if distribution successful, otherwise "NO MATCH"
    remaining_amount.zero? ? result : "NO MATCH"
  end
end
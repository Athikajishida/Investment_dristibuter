# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
bank_accounts = [
  {
    name: 'Account1',
    balance: 10000,
    min_balance_enforced: true,
    min_balance_amount: 1000
  },
  {
    name: 'Account2',
    balance: 5000,
    min_balance_enforced: false,
    min_balance_amount: nil
  },
  {
    name: 'Account3',
    balance: 25000,
    min_balance_enforced: true,
    min_balance_amount: 2000
  },
  {
    name: 'Account4',
    balance: 15000,
    min_balance_enforced: true,
    min_balance_amount: 1000
  },
  {
    name: 'Account5',
    balance: 12000,
    min_balance_enforced: false,
    min_balance_amount: nil
  }
]

bank_accounts.each do |account|
  BankAccount.create!(account)
end

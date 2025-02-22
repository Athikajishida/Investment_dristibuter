#  Investment Dristibution Calculator

A Ruby on Rails application that helps calculate investment distributions across multiple bank accounts based on predefined rules and minimum balance requirements.

## Features

- Store and manage bank account details in database
- Calculate investment distributions based on account balances and minimum balance requirements
- Interactive UI for investment amount input
- Real-time calculation and display of investment distribution
- Handles various investment scenarios including exact matches, single account distributions, and multi-account distributions

## Prerequisites
- Ruby 3.2.0+
- Rails 7.0.0+
- PostgreSQL 14.0+ (or your preferred database)
- Node.js 18.0+ (for asset compilation)
- Yarn or npm

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Athikajishida/Investment_dristibuter.git 
cd Investment_dristibuter
```

2. Install dependencies:
```bash
bundle install
yarn install # or npm install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed # This will populate sample bank account data
```

4. Start the Rails server:
```bash
rails server
```

5. Visit `http://localhost:3000` in your browser

## Database Schema

The application uses a `bank_accounts` table with the following structure:

```ruby
create_table "bank_accounts", force: :cascade do |t|
  t.string "account_name"
  t.decimal "balance", precision: 10, scale: 2
  t.boolean "enforcing_min_balance"
  t.decimal "min_balance_amount", precision: 10, scale: 2
  t.timestamps
end
```

## Usage

1. The homepage displays a list of all bank accounts with their current balances and minimum balance requirements
2. Enter your desired investment amount in the input field
3. Click "Calculate Distribution" to see how the investment amount will be distributed
4. The system will display either:
   - The distribution across one or more accounts
   - "NO MATCH" if the investment amount cannot be satisfied

## Investment Distribution Rules

The system follows these priorities when distributing investments:

1. Exact amount match (considering minimum balance requirements)
2. Single account with sufficient balance
3. Multiple accounts (recursive matching based on rules 1 and 2)

## Example Scenarios

```
Investment: ¥14,000
Result: Account 4 - ¥14,000 (Exact match)

Investment: ¥32,000
Result: 
- Account 1 - ¥9,000
- Account 3 - ¥23,000

Investment: ¥80,000
Result: NO MATCH (Insufficient total funds)
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

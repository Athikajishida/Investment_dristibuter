# @file app/controllers/bank_accounts_controller.rb
# @description BankAccountsController to handle operations related to bank accounts.
# Includes actions to retrieve accounts and calculate investment distribution.
# @version 1.0.0
# @author
#   - Athika Jishida

class BankAccountsController < ApplicationController
  # GET /bank_accounts
  #
  # Renders the index page for bank accounts.
  # Retrieves all bank accounts and initializes the investment result to nil.
  def index
    @bank_accounts = BankAccount.all
    @investment_result = nil
  end

  # POST /bank_accounts/calculate_investment
  #
  # Processes the investment calculation based on the provided investment amount.
  # It retrieves all bank accounts, converts the investment amount from the parameters to a float,
  # and then calls the model method to calculate the investment distribution.
  #
  # The response is handled in two formats:
  #   - turbo_stream: Updates a portion of the page (e.g., via Hotwire Turbo Streams) to show the result.
  #   - html: Renders the index page with the calculated result.
  def calculate_investment
    @bank_accounts = BankAccount.all
    amount = params[:investment_amount].to_f
    @investment_result = BankAccount.calculate_investment_distribution(amount)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "investment_result",
          partial: "investment_result",
          locals: { investment_result: @investment_result }
        )
      end
      format.html do
        render :index
      end
    end
  end
end

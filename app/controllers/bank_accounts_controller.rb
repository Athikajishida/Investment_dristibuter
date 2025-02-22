# app/controllers/bank_accounts_controller.rb
class BankAccountsController < ApplicationController
  def index
    @bank_accounts = BankAccount.all # Get all bank accounts for display
    @investment_result = nil  # Initialize it to nil
  end

  # Handle investment calculation
  def calculate_investment
    @bank_accounts = BankAccount.all
    amount = params[:investment_amount].to_f # Get amount from form
    # Calculate distribution using model method
    @investment_result = BankAccount.calculate_investment_distribution(amount)

    # For Turbo (AJAX) requests, update only the result section
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(
          "investment_result",
          partial: "investment_result",
          locals: { investment_result: @investment_result }
        )
      }
      # For regular requests, render full page
      format.html { 
        render :index
      }
    end
  end
end
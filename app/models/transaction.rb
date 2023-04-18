class Transaction < ApplicationRecord
  # * Associations
  belongs_to :thaali_takhmeen

  # * Callbacks
  after_commit :add_all_transaction_amounts_to_paid_amount

  # * FRIENDLY_ID
  extend FriendlyId
  friendly_id :recipe_no, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    recipe_no_changed?
  end

  # * RANSACK
  ransacker :recipe_no do
      Arel.sql("to_char(\"#{table_name}\".\"recipe_no\", '99999999')")
  end

  # * Validations
  #mode
  validates_presence_of :mode, message: "must be selected"
  #on_date
  validates_presence_of  :on_date, message: "must be selected"
  validates_comparison_of :on_date, less_than_or_equal_to: Time.zone.now.to_date, message: "cannot be in the future", if: :will_save_change_to_on_date?
  #amount
  validates_numericality_of :amount, :recipe_no, only_integer: true, message: "must be a number"
  validates_numericality_of :amount, :recipe_no, greater_than: 0, message: "must be greater than 0"
  # recipe no
  validates_uniqueness_of :recipe_no, message: "has already been registered"

  # * Custom Validations
  validate :amount_should_be_less_than_the_balance, if: :will_save_change_to_amount?

  def amount_should_be_less_than_the_balance
    if self.persisted?
      balance = self.amount_was + self.thaali_takhmeen.balance
      errors.add(:amount, "cannot be greater than the balance") if self.amount > balance

     elsif self.present? && (self.amount > self.thaali_takhmeen.balance)
        errors.add(:amount, "cannot be greater than the balance")
     end
  end

  # * Enums
  enum :mode, %i(cash cheque bank)

  # * Scopes
  scope :that_occured_on, -> date { where(on_date: date)}

  private

    def add_all_transaction_amounts_to_paid_amount
      takhmeen = self.thaali_takhmeen
      all_transactions_of_a_takhmeen = takhmeen.transactions

      if all_transactions_of_a_takhmeen.any?
        total_takhmeen_paid = 0

        all_transactions_of_a_takhmeen.each do |transaction|
          total_takhmeen_paid += transaction.amount if transaction.persisted?
        end

        takhmeen.update_attribute(:paid, total_takhmeen_paid)

      # below logic won't run if takhmeen instance has been destroyed
      elsif takhmeen.persisted?
        takhmeen.update_attribute(:paid, 0)
      end

    end
end

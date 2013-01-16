class ContactDetails
  include Mongoid::Document

  field :address, type: String
  field :confirmed_at, type: DateTime
  field :confirmation_token, type: String
  field :confirmation_sent_at, type: DateTime

  attr_accessible :address

  validates_presence_of :address

  before_create :generate_confirmation_token
  after_create  :send_confirmation_instructions
  before_update :handle_address_change, if: :address_changed?
  after_update  :send_updated_confirmation_instructions, if: :reconfirmation_required?

  def confirmed?
    !!confirmed_at
  end

  # Confirm a record by setting it's confirmed_at to actual time. If the record
  # is already confirmed, add an error to address field. If the record is invalid
  # add errors
  def confirm!
    pending_any_confirmation do
      self.confirmation_token = nil
      self.confirmed_at = Time.now.utc
      save
    end
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.uuid
  end

  def pending_any_confirmation
    if confirmed?
      self.errors.add(:address, :already_confirmed)
      false
    else
      yield
    end
  end

  def handle_address_change
    @reconfirmation_required = true
    generate_confirmation_token
    self.confirmed_at = nil
  end

  def reconfirmation_required?
    @reconfirmation_required
  end

  def send_updated_confirmation_instructions
    send_confirmation_instructions
  end
end

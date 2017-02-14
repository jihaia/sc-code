#
# Table Schema
# ------------
# id            - int(11)      - default NULL
# host_name     - varchar(255) - default NULL
# host_email    - varchar(255) - default NULL
# numgsts       - int(11)      - default NULL
# guest_names   - text         - default NULL
# venue         - varchar(255) - default NULL
# location      - varchar(255) - default NULL
# theme         - varchar(255) - default NULL
# when          - datetime     - default NULL
# when_its_over - datetime     - default NULL
# descript      - text         - default NULL
#
class Party < ApplicationRecord

  ## VALIDATIONS (start) =======================================================
  validates :guest_names, presence: true
  validates :host_name, length: {maximum: 255}
  validates :host_email, length: {maximum: 255}
  validates :venue, length: {maximum: 255}
  validates :location, length: {maximum: 255}
  validates :theme, length: {maximum: 255}

  validate :correct_party_time
  validate :location_required
  ## VALIDATIONS (end)

  ## ASSOCIATIONS (start) ======================================================
  ## ASSOCIATIONS (end)

  ## HOOKS (start) =============================================================
  before_validate :set_defaults
  after_save :clean_guest_names
  ## HOOKS (end)

  ## CLASS METHODS (start) =====================================================
  ## CLASS METHODS (end)

  ## PUBLIC INSTANCE METHODS (start) ===========================================
  ## PUBLIC INSTANCE METHODS (end)

  private

  ## PRIVATE INSTANCE METHODS (start) ==========================================

  def correct_party_time
    if self[:when] > when_its_over
      errors.add(:base,"Incorrect party time.")
    end
  end # def correct_party_time

  def location_required
    unless venue.blank?
      errors.add(:location,"Where is the party?") if location.blank?
    end
  end # def location_is_required

  # Simple helper designed to set any remaining defaults prior to
  # the validation engine kicking in. Only those values to be set will
  # be if the current value is nil.
  #
  # Under normal circumstances I would actually reconsider how this is done to use
  # a concern for the model using meta-programming to provide what is generally
  # considered missing functionality from Rails.
  # For example, use a DSL to configure defaults, ie;
  #   default :numgsts, to: 0
  #   default :some_field, with: :guid
  #   default :another, with: :sequence, named: :my_seq
  def set_defaults
    self.numgsts ||= 0
    self.when_its_over ||= self.when.end_of_day
  end # def set_defaults


  # This a cleansing routine to santize the guest names, stripping runs of spaces
  # to a single space along with prepending the last name (if it is succedded by
  # a middle name/initial) with an underscore.
  #
  # clean "Harry S. Truman" guest name to "Harry S._Truman"
  # clean "Roger      Rabbit" guest name to "Roger Rabbit"
  #
  # The result of cleaning the names will be an update to the instance with
  # the modified value.
  def clean_guest_names
    gnames = []
    guest_names.split(',').each do |g|
      g.squeeze!(' ')
      names=g.split(' ')
      gnames << "#{names[0]} #{names[1..-1].join('_')}"
    end
    guest_names = gnames
    save!
  end # clean_guest_name

  ## PRIVATE INSTANCE METHODS (end)


end # class Party

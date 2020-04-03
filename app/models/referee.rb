class Referee < ActiveRecord::Base
  ADDRESS_TYPES    = ['Home', 'Business', 'RCI', 'Dormitory', 'Other'].freeze
  FIELDS = %w(id name gender adult anonymous phone email address_type outside province_id district_id commune_id village_id current_address house_number outside_address street_number created_at updated_at)
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :village
  belongs_to :state
  belongs_to :subdistrict
  belongs_to :township
  has_many :clients, dependent: :restrict_with_error
  has_many :calls, dependent: :restrict_with_error

  validates :name, presence: true
end

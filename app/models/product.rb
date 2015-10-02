class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :name_led, presence: true
  validates :name_incandescent, presence: true
  validates :price_led, presence: true
  validates :power_incandescent, presence: true
  validates :power_led, presence: true

  has_many :calculation_lines
end

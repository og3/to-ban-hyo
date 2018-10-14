class Role < ApplicationRecord
  has_many :tobanhyos

  validates :name, presence: true

end

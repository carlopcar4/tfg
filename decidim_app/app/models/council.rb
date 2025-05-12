class Council < ApplicationRecord
  validates :name, :province, :population, :status, presence: true
end

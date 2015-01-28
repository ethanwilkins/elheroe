class Subtab < ActiveRecord::Base
  belongs_to :tab
  
  has_many :posts
  has_many :events, dependent: :destroy
  has_many :features, dependent: :destroy
  has_many :hashtags, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :translations, dependent: :destroy
  
  mount_uploader :icon, ImageUploader
  
  reverse_geocoded_by :latitude, :longitude, :address => :address
  after_validation :geocode, :reverse_geocode
  
  scope :pending, -> { where approved: nil }
  scope :approved, -> { where approved: true }
  
  def popularity
    posts.size
  end
end

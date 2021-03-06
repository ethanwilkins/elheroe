# different colors for each choice, highlighting its rank among choices
# proposal polls with up or down votes

class Poll < ActiveRecord::Base
  belongs_to :user
  belongs_to :tab
  has_many :choices
  has_many :comments
  
  mount_uploader :image, ImageUploader
end

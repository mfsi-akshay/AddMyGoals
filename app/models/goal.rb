class Goal < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :body
  self.skip_time_zone_conversion_for_attributes = [:date]
end

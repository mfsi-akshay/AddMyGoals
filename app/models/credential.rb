class Credential < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :username, :password
end

class Message < ActiveRecord::Base
  attr_accessible :flag, :message, :title
  validates_presence_of :title , :message
end

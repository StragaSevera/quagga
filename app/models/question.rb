class Question < ActiveRecord::Base
  validates_presence_of :title, :body
  validates_length_of :title, in: 5..150
  validates_length_of :body, in: 10..10.kilobytes
end

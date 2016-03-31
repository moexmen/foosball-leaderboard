class Match < ActiveRecord::Base
  before_create do
    puts "[SERVER] New match is created at #{self.created_at}"
  end
end

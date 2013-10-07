class Movie < ActiveRecord::Base
  def self.all_ratings
    @ratings = ['G','PG','PG-13','R']
  end

end

class Movie < ActiveRecord::Base
  #the allowable ratings (can be changed for other countries, etc.)

  cattr_reader :ratings
  #An alternative could be:
  #
  #class << self
  # attr_reader :ratings
  #end
  #
  #This would allow subclasses to have their own allowable ratings
  #instead of having to share the parent's ratings.
  

  @@ratings = ['G','PG','PG-13','R']
end

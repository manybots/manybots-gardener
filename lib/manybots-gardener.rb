require "manybots-gardener/engine"

module ManybotsGardener
  
  mattr_accessor :app
  @@app = nil
  
  mattr_accessor :nickname
  @@nickname = nil
  
  def self.setup
    yield self
  end
  
end

require 'ransack'

module Ransack::Naming
  def model_name
    self.class.model_name
  end
end
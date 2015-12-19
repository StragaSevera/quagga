module Introspected
  extend ActiveSupport::Concern

  def model_klass
    controller_name.classify.constantize
  end  
end
module Introspected
  extend ActiveSupport::Concern

  class_methods do
    def model_klass
      controller_name.classify.constantize
    end
  end

  # Выглядит несколько странно, но я не нашел другого способа
  # иметь возможность вызвать model_klass как из экземпляра,
  # так и из самого класса
  def model_klass
    self.class.model_klass
  end  
end
# frozen_string_literal: true

module EnumRender
  class Railtie < ::Rails::Railtie
    initializer "enum_render.initialization" do
      ActiveRecord::Base.send(:include, EnumRender)
    end
  end
end

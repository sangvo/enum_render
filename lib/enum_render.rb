require "enum_render/version"

module EnumRender
  class Error < StandardError; end
  extend ActiveSupport::Concern

  class_methods do
    def enum(opts)
      super(opts)

      klass = self
      singular_model_name = klass.name.singularize.underscore
      locale_prefix = "enums.#{singular_model_name}"

      opts.each do |name, values|
        detect_enum_conflict!(name, "#{name}_name")
        define_method("#{name}_name") do
          return "" if self.send(name).nil?

          I18n.t("#{locale_prefix}.#{name}.#{self.send(name)}", raise: true)
        rescue I18n::MissingTranslationData
          self[name].titleize
        end

        detect_enum_conflict!(name, "#{name}_value")
        define_method("#{name}_value") do
          return nil if self.send(name).nil?

          klass.send(name.to_s.pluralize)[self[name]]
        end

        detect_enum_conflict!(name, "#{name}_option")
        define_method("#{name}_option") do
          return nil if self.send(name).nil?

          value = klass.send(name.to_s.pluralize)[self[name]]
          label = klass.new(name => value).send("#{name}_name")
          {
            "id" => value,
            "label" => label
          }
        end

        detect_enum_conflict!(name, "#{name}_options", true)
        define_singleton_method("#{name}_options") do
          self.send(name.to_s.pluralize).map do |k, _|
            label = self.new(name => k).send("#{name}_name")
            value = self.new(name => k).send("#{name}_value")
            {
              "id" => value,
              "label" => label
            }
          end
        end
      end
    end
  end
end
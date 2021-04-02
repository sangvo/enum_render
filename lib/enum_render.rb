require 'enum_render/version'
require 'enum_render/railtie'
require "enum_render/liberal_enum_type"

module EnumRender
  class Error < StandardError; end

  extend ActiveSupport::Concern

  class_methods do
    def liberal_enum(attribute)
      decorate_attribute_type(attribute) do |subtype|
        EnumRender::LiberalEnumType.new(attribute, defined_enums.fetch(attribute.to_s), subtype)
      end
    end

    def enum(opts)
      super(opts)

      klass = self
      singular_model_name = klass.name.singularize.underscore
      locale_prefix = "enums.#{singular_model_name}"

      opts.each do |name, _values|
        liberal_enum name # To use validate

        detect_enum_conflict!(name, "#{name}_name")
        define_method("#{name}_name") do
          return '' if send(name).nil?

          begin
            I18n.t("#{locale_prefix}.#{name}.#{send(name)}", raise: true)
          rescue I18n::MissingTranslationData
            self[name].titleize
          end
        end

        detect_enum_conflict!(name, "#{name}_value")
        define_method("#{name}_value") do
          return nil if send(name).nil?

          klass.send(name.to_s.pluralize)[self[name]]
        end

        detect_enum_conflict!(name, "#{name}_option")
        define_method("#{name}_option") do
          return nil if send(name).nil?

          label = klass.new(name => self[name]).send("#{name}_name")
          {
            'key' => self[name],
            'value' => label
          }
        end

        detect_enum_conflict!(name, "#{name}_options", true)
        define_singleton_method("#{name}_options") do
          send(name.to_s.pluralize).map do |k, _|
            label = new(name => k).send("#{name}_name")
            key = new(name => k).send(name.to_s)
            {
              'key' => key,
              'value' => label
            }
          end
        end

        detect_enum_conflict!(name, "#{name}_select", true)
        define_singleton_method("#{name}_select") do
          send(name.to_s.pluralize).map do |k, _|
            label = new(name => k).send("#{name}_name")
            key = new(name => k).send(name.to_s)
            [label, key]
          end
        end
      end
    end
  end
end

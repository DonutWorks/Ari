module ApplicationHelper
  def flash_class(level)
    case level.intern
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  class ValidationFormBuilder < ActionView::Helpers::FormBuilder
    def validation_text_field(attribute, label_text, options = { column_width: 10 })
      validation_inline_label(attribute, label_text, { column_width: 12 - options[:column_width] }) do
        @template.text_field(@object_name, attribute, class: "form-control")
      end
    end

    def validation_inline_label(attribute, label_text, options = { column_width: 2 }, &block)
      @template.content_tag(:div, class: "form-group form-group-lg has-feedback #{validation_state(@object, attribute)}") do
        content = @template.label(@object_name, attribute, label_text, class: "col-sm-#{options[:column_width]} control-label")
        content += @template.content_tag(:div, class: "col-sm-#{12 - options[:column_width]}") do
          content = @template.capture(&block)
          content += @template.content_tag(:span, "", class: "glyphicon #{validation_state_feedback(@object, attribute)} form-control-feedback")
          content += @template.content_tag(:span, class: "help-block") do
            attribute_error_message(@object, attribute)
          end
          content.html_safe
        end
        content.html_safe
      end
    end

  private
    def validation_state(model_instance, attribute)
      if model_instance.errors.any?
        if model_instance.errors[attribute].empty?
          "has-success"
        else
          "has-error"
        end
      end
    end

    def validation_state_feedback(model_instance, attribute)
      if model_instance.errors.any?
        if model_instance.errors[attribute].empty?
          "glyphicon-ok"
        else
          "glyphicon-remove"
        end
      end
    end

    def attribute_error_message(model_instance, attribute)
      model_instance.errors[attribute].join('\n')
    end
  end
end
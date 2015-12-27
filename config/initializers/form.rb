module ActionView
  module Helpers
    class FormBuilder 
      def date_select(method, options = {}, html_options = {})
        existing_date = @object.send(method) 
        formatted_date = existing_date.to_datetime.strftime("%m/%d/%Y") if existing_date.present?
        @template.content_tag(:div, :class => "input-group") do    
          text_field(method, :value => formatted_date, :class => "form-control datepicker", :"data-date-format" => "MM/DD/YYYY")
        end
      end

      def datetime_select(method, options = {}, html_options = {})
        existing_time = @object.send(method) 
        formatted_time = existing_time.to_datetime.strftime("%m/%d/%Y %I:%M %p") if existing_time.present?
        @template.content_tag(:div) do    
          text_field(method, :value => formatted_time, :class => "form-control datetimepicker", :"data-date-format" => "MM/DD/YYYY hh:mm A")
        end
      end
    end
  end
end
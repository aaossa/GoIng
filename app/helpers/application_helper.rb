module ApplicationHelper

    def errors_for(object, object_name)
        if object.errors.any?
            content_tag(:div, class: 'card text-white bg-danger mb-3') do
                concat(content_tag(:div, class: 'card-header') do
                    concat "¡Cuidado!"
                end)
                concat(content_tag(:div, class: 'card-body') do
                    concat(content_tag(:h5) do
                        concat "#{pluralize(object.errors.count, "error encontrado", "errores encontrados")} en #{object_name}"
                    end)
                    object.errors.full_messages.each do |msg|
                        concat(content_tag(:p, class: 'card-text') do
                            concat msg
                        end)
                    end
                end)
            end
        end
    end
end

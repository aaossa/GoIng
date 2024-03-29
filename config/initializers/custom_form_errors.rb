# Taken from https://gist.github.com/telwell/db42a4dafbe9cc3b7988debe358c88ad
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = ''

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(#{e}).html_safe
    elsif form_fields.include? e.node_name
      e['class'] = (e['class'] || '') + ' is-invalid'
      if instance.error_message.kind_of?(Array)
        # + is to unfreze (https://stackoverflow.com/a/52929605)
        message = +instance.error_message.to_sentence
        message[0] = message[0].capitalize
        html = %(#{e}<div class="invalid-feedback">#{message}</div>).html_safe
      else
        message = instance.error_message
        message[0] = message[0].capitalize
        html = %(#{e}<div class="invalid-feedback">#{message}</div>).html_safe
      end
    end
  end
  html
end
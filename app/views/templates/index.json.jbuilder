json.array!(@templates) do |template|
  json.extract! template, :template
  json.url template_url(template, format: :json)
end

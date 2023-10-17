module SabeelsHelper
  def font_awesome_button(value)
    # "<i class=''></i> #{value}"
    content_tag(:i, value.to_s, class: "fa-regular fa-file-pdf fa-lg")
  end
end

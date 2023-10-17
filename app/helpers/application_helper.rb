module ApplicationHelper
  include Pagy::Frontend

  def render_flash_message(name, msg)
    case name
    when "success"
      text = "<i class='fa-solid fa-circle-check'></i> #{msg}".html_safe
    when "notice"
      text = "<i class='fa-solid fa-circle-exclamation'></i> #{msg}".html_safe
    when "alert"
      text = "<i class='fa-solid fa-circle-xmark'></i> #{msg}".html_safe
    end

    content_tag :div, text, id: "flash-#{name}"
  end

  def rupees(num)
    num_w_delimeter = number_with_delimiter(num)
    "<i class='fa-solid fa-indian-rupee-sign'></i>#{num_w_delimeter}".html_safe
  end

  def contact_link_tag(icon_tag, url, custom_styles)
    base_styles = "fw-bold btn rounded-5 mb-3 c-bg button-contact"
    all_styles = "#{base_styles} #{custom_styles}"

    link_to(icon_tag.html_safe, url, class: all_styles, target: :_blank)
  end

  def contact_email
    contact_link_tag(
      '<i class=" fa-regular fa-envelope"></i> Email',
      "mailto:juzershakir.webdev@gmail.com",
      "btn-outline-danger"
    )
  end

  def contact_whatsapp
    contact_link_tag(
      '<i class="fa-brands fa-whatsapp"></i> WhatsApp',
      "https://wa.me/919819393148",
      "m-left btn-outline-success"
    )
  end

  def contact_telegram
    contact_link_tag(
      '<i class="fa-brands fa-telegram"></i> Telegram',
      "https://t.me/juzershakir",
      "m-left btn-outline-info"
    )
  end

  def success_btn
    "fw-bold button btn btn-outline-success rounded-5 mb-3 c-bg"
  end

  def danger_btn
    "fw-bold button m-left btn btn-outline-danger rounded-5 mb-3 c-bg"
  end
end

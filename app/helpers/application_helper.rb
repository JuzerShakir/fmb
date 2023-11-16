module ApplicationHelper
  include Pagy::Frontend

  def render_flash_message(type, msg)
    case type
    when "success" then flash_message_helper("success", msg, "check")
    when "notice" then flash_message_helper("notice", msg, "exclamation")
    when "alert" then flash_message_helper("alert", msg, "xmark")
    end
  end

  def rupees(num)
    content_tag :span do
      font_awesome_helper(number_with_delimiter(num), "fa-indian-rupee-sign fa-sm")
    end
  end

  def contact_email
    options = contact_options("mailto:juzershakir.webdev@gmail.com", "btn-outline-danger")

    content_tag(:a, "", options) do
      font_awesome_helper("Email", "fa-regular fa-envelope")
    end
  end

  def contact_whatsapp
    options = contact_options("https://wa.me/919819393148", "m-left btn-outline-success")

    content_tag(:a, "", options) do
      font_awesome_helper("WhatsApp", "fa-brands fa-whatsapp")
    end
  end

  def contact_telegram
    options = contact_options("https://t.me/juzershakir", "m-left btn-outline-info")

    content_tag(:a, "", options) do
      font_awesome_helper("Telegram", "fa-brands fa-telegram")
    end
  end

  def success_btn
    "fw-bold button btn btn-outline-success rounded-5 mb-3 c-bg"
  end

  def danger_btn
    "fw-bold button m-left btn btn-outline-danger rounded-5 mb-3 c-bg"
  end

  private

  def font_awesome_helper(msg, logo)
    concat(content_tag(:i, "", class: "fa-solid #{logo}"))
    concat(content_tag(:span, msg.to_s))
  end

  def flash_message_helper(type, msg, logo)
    content_tag :div, id: "flash-#{type}" do
      font_awesome_helper(msg, "fa-circle-#{logo}")
    end
  end

  def contact_options(url, custom_styles)
    {
      href: url,
      class: "fw-bold btn rounded-5 mb-3 c-bg button-contact #{custom_styles}",
      target: :_blank,
      rel: :noopener
    }
  end
end

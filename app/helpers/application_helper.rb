module ApplicationHelper
  include Pagy::Frontend

  def render_flash_message(type, msg)
    logo = case type
    when "success" then "check"
    when "notice" then "exclamation"
    when "alert" then "xmark"
    end

    content_tag :div, id: "flash-#{type}" do
      font_awesome_helper(" #{msg}", "fa-circle-#{logo}")
    end
  end

  def rupees(num)
    content_tag :span do
      font_awesome_helper(number_with_delimiter(num), "fa-indian-rupee-sign fa-sm")
    end
  end

  def contact_email
    options = set_url("mailto:juzershakir.webdev@gmail.com")

    content_tag(:a, "", options) do
      font_awesome_helper(" Email", "fa-regular fa-envelope")
    end
  end

  def contact_whatsapp
    options = set_url("https://wa.me/919819393148")

    content_tag(:a, "", options) do
      font_awesome_helper(" WhatsApp", "fa-brands fa-whatsapp")
    end
  end

  def contact_telegram
    options = set_url("https://t.me/juzershakir")

    content_tag(:a, "", options) do
      font_awesome_helper(" Telegram", "fa-brands fa-telegram")
    end
  end

  def success_btn
    "fw-bold btn rounded-5 col-8 col-md-4 mb-3 btn-outline-success"
  end

  def danger_btn
    "fw-bold btn rounded-5 col-8 col-md-4 mb-3 btn-outline-danger"
  end

  private

  def font_awesome_helper(msg, fa_styles)
    concat(content_tag(:i, "", class: "fa-solid #{fa_styles}"))
    concat(content_tag(:span, msg.to_s))
  end

  def set_url(url)
    {
      href: url,
      class: "fw-medium btn rounded-5 col-8 col-md-3 mb-3 btn-secondary",
      target: :_blank,
      rel: :noopener
    }
  end
end

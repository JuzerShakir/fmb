module ApplicationHelper
  include Pagy::Frontend

  def contact_email
    options = set_url("mailto:juzershakir.webdev@gmail.com")

    content_tag(:a, "", options) do
      font_awesome_helper(" Email", "fa-regular fa-envelope")
    end
  end

  def contact_telegram
    options = set_url("https://t.me/juzershakir")

    content_tag(:a, "", options) do
      font_awesome_helper(" Telegram", "fa-brands fa-telegram")
    end
  end

  def contact_whatsapp
    options = set_url("https://wa.me/919819393148")

    content_tag(:a, "", options) do
      font_awesome_helper(" WhatsApp", "fa-brands fa-whatsapp")
    end
  end

  def render_flash_message(type, msg)
    logo = case type
    when "success" then "check"
    when "notice" then "exclamation"
    when "alert" then "xmark"
    end

    content_tag :div, id: "flash-#{type}" do
      fa_gen(" #{msg}", "fa-circle-#{logo}")
    end
  end

  def rupees(num)
    content_tag :span do
      fa_gen(number_with_delimiter(num), "fa-indian-rupee-sign fa-sm")
    end
  end

  private

  def fa_gen(content, fa_styles)
    concat(content_tag(:i, "", class: "fa-solid #{fa_styles}"))
    concat(content_tag(:span, msg.to_s))
  end

  def set_url_params_for(url)
    {
      href: url,
      class: "default-btn btn-secondary",
      target: :_blank,
      rel: :noopener
    }
  end
end

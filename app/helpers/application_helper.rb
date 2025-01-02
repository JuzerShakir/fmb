module ApplicationHelper
  include Pagy::Frontend

  def add_rupees_symbol_to(amount, delimiter: false)
    content_tag :span do
      fa_gen(delimiter ? number_with_delimiter(amount) : amount.to_human,
        "fa-indian-rupee-sign fa-xs")
    end
  end

  def fa_btn_gen(text, url, icons)
    content_tag(:a, "", set_url_params_for(url)) do
      fa_gen(text, icons, space: true)
    end
  end

  def render_flash(type, msg)
    logo = flash_icon_for(type)

    content_tag :div, id: "flash-#{type}" do
      fa_gen(msg, "fa-circle-#{logo}", space: true)
    end
  end

  private

  def fa_gen(content, fa_styles, space: false)
    concat(content_tag(:i, "", class: "fa-solid #{fa_styles}"))

    concat(content_tag(:span, " ")) if space
    concat(content_tag(:span, content))
  end

  def flash_icon_for(type)
    case type
    when "success" then "check"
    when "notice" then "exclamation"
    when "alert" then "xmark"
    end
  end

  def set_url_params_for(url)
    {
      href: url,
      class: "btn btn-secondary rounded-pill",
      target: :_blank,
      rel: :noopener
    }
  end
end

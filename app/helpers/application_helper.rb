module ApplicationHelper
  include Pagy::Frontend

  def fa_btn_gen(text, url, icons)
    content_tag(:a, "", set_url_params_for(url)) do
      fa_gen(" #{text}", icons)
    end
  end

  def render_flash(type, msg)
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
      fa_gen(number_with_delimiter(num), "fa-indian-rupee-sign fa-xs")
    end
  end

  private

  def fa_gen(content, fa_styles)
    concat(content_tag(:i, "", class: "fa-solid #{fa_styles}"))
    concat(content_tag(:span, content.to_s))
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

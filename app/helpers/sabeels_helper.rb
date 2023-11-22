module SabeelsHelper
  def pdf_button
    options = {
      href: sabeels_active_url(@apt, format: :pdf),
      class: "default-btn btn-secondary",
      target: :_blank,
      rel: :noopener
    }

    content_tag(:a, "", options) do
      font_awesome_helper(" Generate PDF", "fa-file-pdf fa-lg")
    end
  end
end

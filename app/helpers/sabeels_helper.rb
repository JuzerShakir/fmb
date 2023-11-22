module SabeelsHelper
  def pdf_button
    options = set_url(sabeels_active_url(@apt, format: :pdf))

    content_tag(:a, "", options) do
      font_awesome_helper(" Generate PDF", "fa-file-pdf fa-lg")
    end
  end
end

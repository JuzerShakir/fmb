class ActiveSabeels < Prawn::Document
  def initialize(sabeels, apt)
    super(page_size: "A4", margin: 15)
    @sabeels = sabeels
    @apt = apt

    repeat(:all) do
      header
      @repeat_height = 30
    end

    bounding_box([bounds.left, bounds.top - @repeat_height], width: bounds.width, height: bounds.height - @repeat_height) do
      line_items
    end

    bounding_box([bounds.left, bounds.bottom + 5], width: bounds.width) do
      footer
    end
  end

  def header
    text "#{@apt.titleize} - #{CURR_YR}", size: 20, style: :bold, align: :center
  end

  def line_items
    table(line_items_rows, header: true, position: :center, column_widths: {3 => 200, 5 => 90}) do
      row(0).style font_style: :bold, align: :center, size: 13
      column([1, 4]).style align: :center
      column([2, 5]).style align: :right
      column(0).style font_style: :italic
      column([0, 5]).style text_color: "828385"
    end
  end

  def line_items_rows
    [["#", "Flat No.", "Thaali", "Name", "Size", "Mobile"]] +
      @sabeels.map.with_index do |sabeel, i|
        n = i + 1
        t = sabeel.thaalis.last
        [n, sabeel.flat_no, t.number, t.sabeel_name, t.size.chr.capitalize, sabeel.mobile]
      end
  end

  def footer
    string = "<page>/<total>"
    options = {
      align: :center,
      color: "828385",
      size: 10
    }
    number_pages string, options
  end
end

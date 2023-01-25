class ActiveSabeels < Prawn::Document
    def initialize(sabeels, apt)
        super(page_size: 'A4', page_layout: :landscape)
        @sabeels = sabeels
        @apt = apt
        repeat(:all) {
            header
            @repeat_height = 40
        }
        bounding_box([bounds.left, bounds.top - @repeat_height], width: bounds.width, height: bounds.height - @repeat_height) do
            line_items
        end
    end

    def header
        text "#{@apt.titleize}", size: 25, style: :bold, align: :center
    end

    def line_items
        table(line_items_rows, header: true, position: :center, column_widths: { 0 => 25, 3 => 350, 5 => 150 }) do
            row(0).style font_style: :bold, align: :center, size: 15
            column([1, 4]).style align: :center
            column([2, 5]).style align: :right
            column(0).style font_style: :italic
            column([0, 5]).style text_color: "828385"
            column(0..5).style padding_top: 10, padding_bottom: 10
        end
    end

    def line_items_rows
        [["#", "Flat No.", "Thaali", "Name", "Size", "Mobile"]] +
        @sabeels.map.with_index do |sabeel, i|
            n = i + 1
            t = sabeel.thaali_takhmeens.last
            [n, sabeel.flat_no, t.number, sabeel.hof_name, t.size.chr.capitalize, sabeel.mobile]
        end
    end
end
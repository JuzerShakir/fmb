module ArrayExtensions
  refine Array do
    def to_h_titleize_value
      to_h { [_1, _1.to_s.titleize] }
    end
  end
end

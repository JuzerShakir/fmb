module ArrayExtensions
  refine Array do
    def to_h_titleize_value = to_h { [it, it.to_s.titleize] }
  end
end

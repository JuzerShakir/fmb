module ActiveRecordRelationExtensions
  refine ActiveRecord::Relation do
    def union(q)
      union_query = Arel::Nodes::Union.new(arel, q.arel).as(klass.table_name)
      klass.from(union_query)
    end
  end
end

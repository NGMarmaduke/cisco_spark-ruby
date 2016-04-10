module DataCaster
  Array = lambda { |data| data }
  Boolean = lambda { |data| data }
  String = lambda { |data| data.to_s }
  DateTime = lambda { |data| data ? ::DateTime.parse(data) : nil }
end
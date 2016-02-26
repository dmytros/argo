class Node
  attr_accessor :object_id, :object_type, :adjacents

  def initialize(object_id, object_type)
    @adjacents = Set.new
    @object_id, @object_type = object_id, object_type
  end
end
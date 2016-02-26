class DepthFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
    @visited = []
    @edge_to = {}

    dfs(source_node)
  end

  def path_to(node)
    return unless has_path_to?(node)
    path = []
    current_node = node

    while(current_node != @source_node) do
      path.unshift(current_node)
      current_node = @edge_to[current_node]
    end

    path.unshift(@source_node)
  end

  private
  def dfs(node)
    @visited << node
    node.adjacents.each do |adj_node|
      next if @visited.include?(adj_node)

      dfs(adj_node)
      @edge_to[adj_node] = node
    end
  end

  def has_path_to?(node)
    @visited.include?(node)
  end
end

=begin
# Example of usage

n1 = Node.new(1, 'reports')
n2 = Node.new(2, 'reports')
n3 = Node.new(1, 'components')
n4 = Node.new(2, 'components')
n5 = Node.new(3, 'components')
n6 = Node.new(4, 'components')
n7 = Node.new(5, 'components')
n8 = Node.new(1, 'components')

g = Graph.new

g.add_edge(n1, n3)
g.add_edge(n3, n4)
g.add_edge(n3, n5)
g.add_edge(n5, n6)

g.add_edge(n2, n7)
g.add_edge(n7, n8)

p1 = DepthFirstSearch.new(g, n1).path_to(n6)
p2 = DepthFirstSearch.new(g, n2).path_to(n8)

=end
class BreathFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @node = source_node
    @visited = []
    @edge_to = {}

    bfs(source_node)
  end

  def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @node) do
      path.unshift(node)
      node = @edge_to[node]
    end

    path.unshift(@node)
  end

  private
  def bfs(node)
    queue = []
    queue << node
    @visited << node

    while queue.any?
      current_node = queue.shift # remove first element
      current_node.adjacents.each do |adjacent_node|
        next if @visited.include?(adjacent_node)
        queue << adjacent_node
        @visited << adjacent_node
        @edge_to[adjacent_node] = current_node
      end
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

p1 = BreathFirstSearch.new(g, n1).shortest_path_to(n6)
p2 = BreathFirstSearch.new(g, n2).shortest_path_to(n8)

=end
class ConnectedComponent
  attr_accessor :connected_components

  def initialize(graph)
    @graph = graph
    @visited = []
    @connected_components = {}

    counter = 0
    @graph.nodes.each do |node|
      next if @visited.include?(node)

      dfs(node, counter)
      counter += 1
    end
  end

  private
  def dfs(node, counter)
    @visited << node
    @connected_components[counter] ||= []
    @connected_components[counter] << node

    node.adjacents.each do |adj_node|
      dfs(adj_node, counter) unless @visited.include?(adj_node)
    end
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
g.nodes = [n1, n2, n3, n4, n5, n6, n7, n8]

g.add_edge(n1, n3)
g.add_edge(n3, n4)
g.add_edge(n3, n5)
g.add_edge(n5, n6)

g.add_edge(n2, n7)
g.add_edge(n7, n8)

connected_components = ConnectedComponent.new(g).connected_components.values

=end
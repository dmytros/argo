# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['boolean', 'integer', 'numeric', 'character', 'string', 'text', 'date', 'time', 'datetime', 'any', 'unknown'].each {|item| Cast.create(name: item.capitalize, sys: item)}
#Source.create(name: 'mysql', username: 'root', host: 'localhost', port: '3306', database: 'logistic', password: '', adapter: 'mysql2', encoding: 'unicode', pool: 5)
#Source.create(name: 'postgres', username: 'testuser', host: 'localhost', port: '5432', database: 'test', password: 'test', adapter: 'postgresql', encoding: 'unicode', pool: 5)
#0.upto(10) {|i| Report.create(name: "Report ##{i}", source_id: 1, sql: 'SELECT * FROM users')}
0.upto(10) {|i| Component.create(name: "Component ##{i}")}
Component.all.each { |co|
  ca_in = Cast.find(rand(4) + 1)
  ca_out = Cast.find(rand(4) + 1)

  ComponentCast.create(component_id: co.id, cast_id: ca_in.id, position: 'in')
  ComponentCast.create(component_id: co.id, cast_id: ca_out.id, position: 'out')
}
[{name: 'Administrator', sys_name: 'admin'}, {name: 'User', sys_name: 'user'}].each do |role|
  Role.create(role)
end
User.create(name: 'admin', password: 'adminpwd', role_id: Role.where(sys_name: 'admin').first.id, is_active: true)

['table', 'line', 'column', 'pie'].each {|name| Widget.create(name: name.upcase, sys: name)}

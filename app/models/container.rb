# == Schema Information
#
# Table name: containers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Container < ActiveRecord::Base
  def self.tree(tree)
    tree.each do |key, branch|
      if branch['type'] === 'reports'
        report = Report.find(branch['id'])
        branch['observations'] = report.observations
      end
    end
  end
end

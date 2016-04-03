# == Schema Information
#
# Table name: sources
#
#  id          :integer          not null, primary key
#  name        :string
#  username    :string
#  host        :string
#  port        :string
#  database    :string
#  password    :string
#  adapter     :string
#  encoding    :string
#  pool        :string
#  destination :string           default("database")
#  path        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Source < ActiveRecord::Base
  include Connection
  
  ADAPTERS = ['mysql2', 'postgresql', 'sqlite3']
  DESTINATIONS = ['database', 'file', 'socket']
  
  DATABASE = 0
  FILE = 1
  SOCKET = 2
  
  validates :destination, presence: true
  validates :name, presence: true, uniqueness: true
  
  # database validations
  validates :host, :username, :port, :database, :adapter, presence: true, if: :is_database?
  validates :adapter, inclusion: {in: ADAPTERS}, if: :is_database?
  validates :port, numericality: true, if: :is_database?
  validates :host, uniqueness: {scope: [:port, :database, :username, :password, :adapter]}, if: :is_database?
  
  # file validations
  validates :path, presence: true, if: :is_file?
  
  before_save :clear_fields
  
  has_many :reports, :dependent => :destroy
  
  def use_database?
    is_database?
  end

  def use_file?
    is_file?
  end

  def has_connection?
    self.ping
  end
  
  def tree
    tree = {}
    
    list = self.tables
    
    if ('ok' === list['status'])
      for column in list['data']
        unless tree.has_key?(column['table_name'])
          tree[column['table_name']] = []
        end
        
        tree[column['table_name']] << {
          'column_name' => column['column_name'],
          'column_type' => column['data_type']
        }
      end
    end
    
    tree
  end
  
  private
  def is_database?
    destination == DESTINATIONS[0]
  end

  def is_file?
    destination == DESTINATIONS[1]
  end
  
  def clear_fields
    self.adapter = '' if destination == DESTINATIONS[1]
  end
end

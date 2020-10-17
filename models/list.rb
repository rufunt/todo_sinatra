require 'sequel'

class List < Sequel::Model
  set_primary_key :id

  one_to_many :items
  one_to_many :permissions
  one_to_many :logs
end

class Item < Sequel::Model
  set_primary_key :id

  many_to_one :user
  many_to_one :list
end

def self.new_list name, items, user
  list = List.create(name: name, created_at: Time.now)
  items.each do |item|
    Item/create(name: item[:name], description: item[:description], list: list, user: user,created_at: Time.now, updated_at: Time.now)
  end
  Permission.create(list: list, user: user, permission_level: 'read_write', created_at: Time.now, updated_at: Time.now)

  return list 
end
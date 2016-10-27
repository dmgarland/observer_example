class Item
  attr_accessor :name, :quantity

  def initialize(name, quantity)
    @name, @quantity = name, quantity
  end

  def ==(some_other_item)
    @name == some_other_item.name
  end

  def save
    sql = %{INSERT INTO items (name, quantity) VALUES (?,?);}
    Warehouse.db.execute sql, name, quantity
  end

  def self.make_table
    sql = <<SQL
  CREATE TABLE IF NOT EXISTS items (
    id integer primary key autoincrement,
    name text,
    quantity integer
  )
SQL
    Warehouse.db.execute sql
  end
end

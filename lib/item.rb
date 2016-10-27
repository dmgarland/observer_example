class Item
  attr_accessor :id, :name, :quantity

  def initialize(id: nil, name:, quantity:)
    @id, @name, @quantity = id, name, quantity
  end

  def ==(some_other_item)
    @name == some_other_item.name
  end

  def attributes
    {
      id: @id,
      name: @name,
      quantity: @quantity
    }
  end

  def save
    Warehouse.db.transaction do |db|
      sql = %{INSERT INTO items (name, quantity) VALUES (?,?);}
      db.execute sql, name, quantity

      # Find the item from the last thing we saved
      @id = db.execute("select max(id) from items")[0][0]
    end
  end

  def update(changes)
    sql = <<SQL
    UPDATE items SET name = :name, quantity = :quantity
    WHERE id = :id
SQL
    Warehouse.db.execute sql, attributes.merge(changes)

    # Update the instance variables in memory as well
    changes.each do |method, value|
      self.send "#{method}=", value
    end
  end

  def delete
    Warehouse.db.execute("DELETE from items where id = ?", @id)
  end

  class << self
    def all
      build_items Warehouse.db.execute("SELECT * from items")
    end

    def find(id)
      results = Warehouse.db.execute("SELECT * from items where id = ?", id)
      build_items(results).first
    end

    def make_table
    sql = <<SQL
  CREATE TABLE IF NOT EXISTS items (
    id integer primary key autoincrement,
    name text,
    quantity integer
  )
SQL
      Warehouse.db.execute sql
    end

    private
    def build_items(results)
      results.map do |result|
        Item.new(id: result[0], name: result[1], quantity: result[2])
      end
    end
  end

end

class Warehouse
  attr_reader :orders

  STOCK_LEVEL_THRESHOLD = 3

  include Observable

  def initialize
    @items = []
    @orders = []
    Item.make_table
  end

  def self.db(environment = "test")
    SQLite3::Database.new("db/#{environment}.db")
  end

  def add(item)
    @items << item
    item.save
    notify_observers :added_item, item
  end

  def update(item, changes)
    existing_item = @items.find { |i| i == item }

    changes.each do |method, value|
      existing_item.send "#{method}=".to_sym, value
    end

    # Need to check that the item's quantity hasn't fallen below a given value
    if existing_item.quantity < STOCK_LEVEL_THRESHOLD
      notify_observers :low_stock, self, existing_item
    end

    notify_observers :updated, existing_item
  end
end

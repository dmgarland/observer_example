class Warehouse
  attr_reader :orders

  STOCK_LEVEL_THRESHOLD = 3

  include Observable

  def initialize
    @items = []
    @orders = []
  end

  def add(item)
    @items << item
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

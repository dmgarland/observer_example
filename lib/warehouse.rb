class Warehouse
  attr_reader :orders

  STOCK_LEVEL_THRESHOLD = 3
  REORDER_QUANTITY = 10

  def initialize
    @items = []
    @orders = []
  end

  def add(item)
    @items << item
  end

  def update(item, changes)
    existing_item = @items.find { |i| i == item }

    changes.each do |method, value|
      existing_item.send "#{method}=".to_sym, value
    end

    # Need to check that the item's quantity hasn't fallen below a given value
    if existing_item.quantity < STOCK_LEVEL_THRESHOLD
      # We need to re-order the item
      @orders << Item.new(existing_item.name, REORDER_QUANTITY)
    end
  end
end

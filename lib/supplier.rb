Supplier = Struct.new(:name) do
  REORDER_QUANTITY = 10

  def call(event, *args)
    reorder *args if event == :low_stock
  end

  def reorder(warehouse, existing_item)
    warehouse.orders << Item.new(name: existing_item.name, quantity: REORDER_QUANTITY)
  end

end
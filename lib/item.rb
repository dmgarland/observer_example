class Item < ActiveRecord::Base

  after_save :reorder_stock, :if => :stock_required?

  def stock_required?
    quantity < Warehouse::STOCK_LEVEL_THRESHOLD
  end

  private
  def reorder_stock
    Supplier.new.call(:low_stock, Warehouse.new, self)
  end

end

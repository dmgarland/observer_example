require "minitest/autorun"
require "minitest/emoji"

require_relative "../lib/item"
require_relative "../lib/warehouse"

class WarehouseSpec < MiniTest::Spec

  describe "A Warehouse" do
    before do
      @warehouse = Warehouse.new

      item = Item.new("Baked Beans", 5)
      @warehouse.add(item)

      @warehouse.update item, { quantity: 2 }
    end

    it "automatically notifies us that the stock fell below a certain level" do
      @warehouse.orders.must_equal [Item.new("Baked Beans", 10)]
    end
  end

end
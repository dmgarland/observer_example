require "minitest/autorun"
require "minitest/emoji"

require_relative "../lib/observable"
require_relative "../lib/item"
require_relative "../lib/supplier"
require_relative "../lib/warehouse"

class WarehouseSpec < MiniTest::Spec

  describe "A Warehouse" do
    before do
      @warehouse = Warehouse.new
      @supplier = Supplier.new

      # Allow the supplier to register an interest in the Warehouse
      @warehouse.add_observer @supplier
      @warehouse.add_observer lambda { |event, *args| File.open('log.txt', 'a') {|f| f.write "#{event} #{args.join " "}\n" }}

      item = Item.new("Baked Beans", 5)
      @warehouse.add(item)

      @warehouse.update item, { quantity: 2 }
    end

    it "automatically notifies us that the stock fell below a certain level" do
      @warehouse.orders.must_equal [Item.new("Baked Beans", 10)]
    end
  end

end
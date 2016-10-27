require "minitest/autorun"
require "minitest/emoji"

require "sqlite3"

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
      @item = Item.new("Baked Beans", 5)
      @warehouse.add @item
    end

    after do
      Warehouse.db.execute "DELETE from items"
    end

    it "stores the item in a database" do
      results = Warehouse.db.execute("select * from items")
      results.first[0].wont_be_nil
      results.first[1].must_equal "Baked Beans"
      results.first[2].must_equal 5

      results = Warehouse.db.execute("select count(*) from items")
      results.first[0].must_equal 1
    end

    describe "with an updated item" do
      before do
       @warehouse.update @item, { quantity: 2 }
      end

      it "automatically notifies us that the stock fell below a certain level" do
        @warehouse.orders.must_equal [Item.new("Baked Beans", 10)]
      end
    end
  end

end
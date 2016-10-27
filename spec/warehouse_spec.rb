require "minitest/autorun"
require "minitest/emoji"
require "pry-byebug"
require "sqlite3"
require "active_record"

require_relative "../lib/item"
require_relative "../lib/supplier"
require_relative "../lib/warehouse"
require_relative "../lib/order"

ActiveRecord::Base.establish_connection(
  :adapter => :sqlite3,
  :database => 'db/test.db'
)

class WarehouseSpec < MiniTest::Spec
  def db(environment = "test")
    SQLite3::Database.new("db/#{environment}.db")
  end

  describe "A Warehouse" do
    before do
      @supplier = Supplier.new

      @item = Item.new(name: "Baked Beans", quantity: 5)
      @item.save
    end

    after do
      Item.delete_all
      Order.delete_all
    end

    it "stores the item in a database" do
      results = db.execute("select * from items")
      results.first[0].wont_be_nil
      results.first[1].must_equal "Baked Beans"
      results.first[2].must_equal 5

      results = db.execute("select count(*) from items")
      results.first[0].must_equal 1
    end

    describe "with an updated item" do
      before do
       @item.update(name: "Heinz Baked Beans",  quantity: 2)
      end

      it "updates the item in the database" do
        results = db.execute("select * from items")
        results.first[0].wont_be_nil
        results.first[1].must_equal "Heinz Baked Beans"
        results.first[2].must_equal 2
      end

      it "automatically notifies us that the stock fell below a certain level" do
        Order.count.must_equal 1
      end
    end

    describe "deleting an item" do
      before do
        @item.delete
      end

      it "removes the item" do
        results = db.execute("select count(*) from items")
        results.first[0].must_equal 0
      end
    end

    describe "retreiving all items" do
      before do
        @items = Item.all
      end

      it "builds an array of items" do
        @items.must_equal [Item.new(id: @item.id, name: "Baked Beans", quantity: 5)]
      end
    end

  end
end
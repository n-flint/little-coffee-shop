require 'rails_helper'

RSpec.describe Cart do
  subject {       # subject is RSpec similar to before :each
    Cart.new({
      '1' => 2,   # two copies of item 1
      '2' => 3    # three copies of item 2
    })
  }

  before :each do
    @item_1 = create(:item)
    @item_2 = create(:item)
    @cart = Cart.new({
      @item_1.id => 2,   # two copies of item 1
      @item_2.id => 3    # three copies of item 2
      })
  end

  describe 'Instance methods' do
    describe "#total_count" do
      it 'can calculate the total number of items it holds' do
        expect(subject.total_count).to eq(5)
      end
    end

    describe "#add_item" do
      it 'adds an item to its contents' do
        subject.add_item(1)
        subject.add_item(2)

        expect(subject.contents).to eq({'1' => 3, '2' => 4})
      end
    end

    describe "#deduct_item" do
      it 'deducts an item to its contents' do
        subject.deduct_item(1)
        subject.deduct_item(2)

        expect(subject.contents).to eq({'1' => 1, '2' => 2})
      end

      it 'deletes an item if its quantity reaches 0' do
        subject.deduct_item(1)
        subject.deduct_item(1)

        expect(subject.contents).to eq({'2' => 3})
      end
    end

    describe "#count_of" do
      it 'adds returns the count of an item_id in the cart' do
        expect(subject.count_of(1)).to eq(2) # two copies of item 1
        expect(subject.count_of(5)).to eq(0) # zero copies of item 5
      end
    end

    describe "#items" do
      it 'returns a hash where the keys are Item objects and values are quantites' do
        expected = {
          @item_1 => 2,
          @item_2 => 3
        }

        expect(@cart.items).to eq(expected)
      end
    end

    describe "#grand_total" do
      it 'returns a grand total price of all items in cart' do
        item_1_quantity = @cart.contents[@item_1.id]
        item_2_quantity = @cart.contents[@item_2.id]

        expected = @item_1.price * item_1_quantity + @item_2.price * item_2_quantity

        expect(@cart.grand_total).to eq(expected)
      end
    end

    describe "#empty?" do
      it 'returns true of the cart is empty' do
        empty_cart = Cart.new(nil)

        expect(empty_cart.empty?).to eq(true)
      end

      it 'returns false when the cart has items' do
        expect(@cart.empty?).to eq(false)
      end
    end

    describe "#empty_cart" do
      it 'empties the cart' do
        expect(@cart.empty?).to eq(false)

        @cart.empty_cart

        expect(@cart.empty?).to eq(true)
      end
    end

    describe "#generate_order" do
      it 'creates one order and all order_items from a cart' do
        user = create(:user)
        item_1 = create(:item)
        item_2 = create(:item)

        cart = Cart.new({
          item_1.id.to_s => 2,   # two copies of item 1
          item_2.id.to_s => 3    # three copies of item 2
        })

        cart.generate_order(user)

        order = Order.last
        expect(order.user_id).to eq(user.id)

        order_item_1 = OrderItem.first
        order_item_2 = OrderItem.last

        expect(order_item_1.order_id).to eq(order.id)
        expect(order_item_1.item_id).to eq(item_1.id)
        expect(order_item_1.order_price).to eq(item_1.price)
        expect(order_item_1.quantity).to eq(cart.contents[item_1.id.to_s])

        expect(order_item_2.order_id).to eq(order.id)
        expect(order_item_2.item_id).to eq(item_2.id)
        expect(order_item_2.order_price).to eq(item_2.price)
        expect(order_item_2.quantity).to eq(cart.contents[item_2.id.to_s])
      end
    end
  end
end

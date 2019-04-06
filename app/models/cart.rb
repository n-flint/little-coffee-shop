class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
    @contents.default = 0
  end

  def total_count
    @contents.values.sum
  end

  def add_item(id)
    @contents[id.to_s] = @contents[id.to_s] + 1
  end

  def count_of(id)
    @contents[id.to_s].to_i
  end

  def items
    items_hash = Hash.new(0)
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      items_hash[item] = quantity
    end
    items_hash
  end

  def sub_total(item, quantity)
    item.price * quantity
  end

  def grand_total
    total = 0.0
    items.each do |item, quantity|
      total += item.price * quantity
    end
    total
  end

end

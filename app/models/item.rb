class Item < ApplicationRecord
  before_validation :item_cost

  validates_presence_of :name, :cost

  private

    def item_cost
      self.cost = RabbitService.call(name, 'item_cost')
    end
end

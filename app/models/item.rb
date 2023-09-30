class Item < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  belong_to :genre
  has_many :orders, through: :order_details

  attachment :image

  varidates :name, presence: true
  varidates :image, presence: true
  varidates :introduction, presence: true
  varidates :price, presence: true
  varidates :genre_id, presence: true

  def self.search_for(content,method)
    return none if content.blank?
    if method == 'perfect'
      Item.where(name: content)

    elsif method == 'forward'
      Item.where('name LIKE ?', content + '%')

    elsif method == 'backword'
      Item.where('name LIKE ?', '%' + content)

    else
      Item.where('name LIKE ?', '%' + content + '%')
    end
  end
end

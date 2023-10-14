class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :deliveries, dependent: :destroy
  has_many :addresses

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true
  validates :email, uniqueness: true

  def self.search_for(content,method)
    return none if content.blank?
     if method == 'forward'
      # カラムが2つの部分を1つに補う
       f_customer = Customer.where('first_name LIKE ?',content + '%')
       l_customer = Customer.where('last_name LIKE ?',content + '%')

       customers = f_customer + l_customer
     elsif method == 'backword'
       Customer.where('first_name LIKE ?', '%' + content)
       f_customer = Customer.where('first_name LIKE ?', '%' + content)
       l_customer = Customer.where('last_name LIKE ?', '%' + content)

       customers = f_customer + l_customer
     else
       f_customer = Customer.where('first_name LIKE ?', '%' + content + '%')
       l_customer = Customer.where('last_name LIKE ?', '%' + content + '%')

       customers = f_customer + l_customer
     end
     return customers
  end

  # falseならtrueを返すようにしている
  def active_for_authentication?
    super && (self.is_active == true)
  end
end

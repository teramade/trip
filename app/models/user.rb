class User < ApplicationRecord

  DEFAULT_NICK_NAME = "ニックネーム"
  DEFAULT_ICON_IMAGE = "hikouki.jpeg"

  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable

  has_many :trips

  has_one_attached :icon

  before_create :set_default_values


  private

  def set_default_values
    unless self.nickname
      self.nickname = DEFAULT_NICK_NAME
    end

    unless self.icon.attached?
      default_image_path = Rails.root.join("app", "assets","images", DEFAULT_ICON_IMAGE)
      default_image = File.open(default_image_path)
      self.icon.attach(io: default_image, filename: 'icon.jpg', content_type: 'image/jpeg')
    end
    
  end

end

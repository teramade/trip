class Trip < ApplicationRecord
    validates :title,{presence:true}
    validates :photo,{presence:true}

    belongs_to :user

    has_one_attached :photo

    acts_as_taggable_on :tags
end

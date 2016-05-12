class Group < ActiveRecord::Base
    validates :title, presence: true
    has_many :posts, dependent: :destroy
    has_many :group_users
    has_many :members, through: :group_users, source: :user
    belongs_to :owner, class_name: "User", foreign_key: :user_id
    def editable_by?(user)
       #(user(存在/true)) && (user == owner) 
       #這條判斷式左半邊user的boolean會為true 但另外一邊 user==owner的boolean為false
       #就是這樣的機制 讓只有是文章的作者才能夠編集文章
       user && user == owner 
    end
end

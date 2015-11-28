class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  scope :ordered_all, lambda {
    all.order('post_count DESC')
  }

  def self.clean_unassociated
    Tag.includes(:posts).where(:posts => { :id => nil }).each(&:delete)
  end
end

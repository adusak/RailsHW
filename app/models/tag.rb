class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  validates_format_of :name, :with => /[^.]+/

  scope :ordered_all, lambda {
    select('DISTINCT *, count(posts_tags.post_id) AS post_count')
      .joins(:posts)
      .group('tags.name, tags.id')
      .order('post_count DESC')
  }

  def self.clean_unassociated
    Tag.includes(:posts).where(:posts => { :id => nil }).each(&:delete)
  end
end

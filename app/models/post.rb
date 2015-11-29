class TagsStringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.split(/[\s,.]+/).map(&:strip).length > 0
      record.errors[attribute] << (options[:message] || "must have at least one tag")
    end
  end
end

class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags

  attr_accessor :post_tags_string

  before_save :parse_tags
  before_destroy :decrement_post_counter
  after_commit { Tag.clean_unassociated }

  validates :author, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :post_tags_string, tags_string: true

  public

  def tags_string
    tags.map(&:name) * ', '
  end

  private

  def decrement_post_counter
    tags.each { |t| t.decrement!(:post_count) }
  end

  private

  def parse_tags
    self.tags = []
    my_tags = post_tags_string.split(/[\s,.]+/).map(&:strip)
    my_tags.each do |name|
      t = Tag.find_or_create_by(name: name)
      t.increment(:post_count)
      t.save
      tags << t unless tags.include?(t)
    end
  end
end


class ContentUserSearch < DomainModel
  belongs_to :content_search_keyword
  has_end_user :end_user_id
  belongs_to :domain_log_visitor

  validates_presence_of :content_search_keyword_id

  named_scope :valid_keywords, :joins => :content_search_keyword, :conditions => 'content_search_keywords.approved = 1 AND content_search_keywords.has_results = 1'
  named_scope :searches_between, lambda { |from, to| {:conditions => ['content_user_searches.created_at >= ? AND content_user_searches.created_at < ?', from, to]} }


  def self.push_user_search(end_user, keyword)
    ContentUserSearch.first(:conditions => {:end_user_id => end_user.id, :content_search_keyword_id => keyword.id}) || ContentUserSearch.create(:end_user_id => end_user.id, :content_search_keyword_id => keyword.id)
  end

  def self.push_visitor_search(visitor, keyword)
    ContentUserSearch.first(:conditions => {:domain_log_visitor_id => visitor.id, :content_search_keyword_id => keyword.id}) || ContentUserSearch.create(:domain_log_visitor_id => visitor.id, :content_search_keyword_id => keyword.id)
  end

  def self.searches_scope(from, duration, opts={})
    scope = ContentUserSearch.valid_keywords.searches_between(from, from+duration)
    scope = scope.scoped(:select => 'count(content_search_keyword_id) as hits, content_search_keyword_id as target_id', :group => 'target_id')
    scope
  end

  def self.searches(from, duration, intervals, opts={})
    DomainLogGroup.stats('ContentSearchKeyword', from, duration, intervals) do |from, duration|
      self.searches_scope from, duration, opts
    end
  end
end

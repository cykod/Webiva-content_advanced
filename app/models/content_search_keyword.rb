
class ContentSearchKeyword < DomainModel
  has_many :content_user_searches, :dependent => :delete_all

  validates_presence_of :keyword

  def self.webiva_search_stats_handler_info
    { 
      :name => 'Advanced Content Search Stats'
    }
  end

  def num_searches
    @num_searches ||= self.content_user_searches.count
  end

  def self.push_search(end_user, visitor, keyword, has_results=true)
    keyword = keyword.strip.downcase.capitalize
    search_keyword = ContentSearchKeyword.find_by_keyword(keyword) || ContentSearchKeyword.create(:keyword => keyword, :has_results => has_results)
    search_keyword.update_attribute(:has_results, has_results) if search_keyword.has_results != has_results

    if end_user.id
      ContentUserSearch.push_user_search end_user, search_keyword
    else
      ContentUserSearch.push_visitor_search visitor, search_keyword
    end
  end

  def self.update_search_stats(end_user, visitor, content_node_search)
    self.push_search(end_user, visitor, content_node_search.terms, content_node_search.total_results > 0)
  end
end

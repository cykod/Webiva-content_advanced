
class ContentSearchKeyword < DomainModel
  has_many :content_user_searches, :dependent => :delete_all

  validates_presence_of :keyword

  def num_searches
    @num_searches ||= self.content_user_searches.count
  end

  def keyword=(word)
    word = word.strip.downcase.capitalize if word
    self.write_attribute(:keyword, word)
  end

  def self.push_search(end_user, visitor, keyword, has_results=true)
    search_keyword = ContentSearchKeyword.find_by_keyword(keyword) || ContentSearchKeyword.create(:keyword => keyword, :has_results => has_results)
    search_keyword.update_attribute(:has_results, has_results) if search_keyword.has_results != has_results

    if end_user.id
      ContentUserSearch.push_user_search end_user, search_keyword
    else
      ContentUserSearch.push_visitor_search visitor, search_keyword
    end
  end
end

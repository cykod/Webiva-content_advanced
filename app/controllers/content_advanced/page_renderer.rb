
class ContentAdvanced::PageRenderer < ParagraphRenderer

  features '/content_advanced/page_feature'

  paragraph :search_trends

  def search_trends
    @options = paragraph_options :search_trends
    from = @options.days_ago.days.ago.at_midnight
    duration = (@options.days_ago + 1).days
    groups = ContentUserSearch.searches @options.days_ago.days.ago.at_midnight, duration, 1
    group = groups[0]
    target_ids = group.domain_log_stats.find(:all, :order => 'hits DESC', :limit => @options.limit).collect(&:target_id)
    @keywords = ContentSearchKeyword.find :all, :conditions => {:id => target_ids, :approved => true, :has_results => true}
    render_paragraph :feature => :content_advanced_page_search_trends
  end
end


class ContentAdvanced::PageRenderer < ParagraphRenderer

  features '/content_advanced/page_feature'

  paragraph :search_trends
  paragraph :most_viewed_content

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

  def most_viewed_content
    @options = paragraph_options :most_viewed_content
    from = @options.days_ago.days.ago.at_midnight
    duration = (@options.days_ago + 1).days

    groups = ContentNode.traffic from, duration, 1
    group = groups[0]
    target_ids = group.domain_log_stats.find(:all, :order => 'hits DESC', :limit => @options.limit).collect(&:target_id)
    @most_viewed = ContentNode.all :conditions => {:id => target_ids}

    groups = Comment.commented from, duration, 1
    group = groups[0]
    target_ids = group.domain_log_stats.collect(&:target_id)
    @most_commented = ContentNode.all :conditions => {:id => target_ids}

    groups = Share::EmailFriend.emailed from, duration, 1
    group = groups[0]
    target_ids = group.domain_log_stats.collect(&:target_id)
    @most_shared = ContentNode.all :conditions => {:id => target_ids}
    render_paragraph :feature => :content_advanced_page_most_viewed_content
  end
end

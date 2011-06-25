
class ContentAdvanced::PageRenderer < ParagraphRenderer

  features '/content_advanced/page_feature'

  paragraph :search_trends
  paragraph :most_viewed_content

  def search_trends

    results = renderer_cache(nil,nil,:expires => 360) do |cache|
      @options = paragraph_options :search_trends
      from = @options.days_ago.days.ago.at_midnight
      duration = (@options.days_ago + 1).days
      groups = ContentUserSearch.searches @options.days_ago.days.ago.at_midnight, duration, 1
      group = groups[0]
      target_ids = group.domain_log_stats.find(:all, :order => 'hits DESC', :limit => @options.limit).collect(&:target_id)
      @keywords = ContentSearchKeyword.find :all, :conditions => {:id => target_ids, :approved => true, :has_results => true}
      cache[:output] = content_advanced_page_search_trends_feature
    end

    render_paragraph :text => results.output
  end

  def most_viewed_content

    results = renderer_cache(nil,nil,:expires => 360) do |cache|
      @options = paragraph_options :most_viewed_content
      from = @options.days_ago.days.ago.at_midnight
      duration = (@options.days_ago + 1).days

      data = delayed_cache_fetch(ContentAdvancedData,:most_viewed_content,
                                                                    { :from => from, :duration => duration,
                                                                      :limit => @options.limit },
                                                                       
                                                                       nil,:expires => 5)
      
      if data
        @most_viewed = data[:most_viewed]
        @most_commented = data[:most_commented]
        @most_shared = data[:most_shared] 
      end

      if @most_viewed 
        cache[:output] = content_advanced_page_most_viewed_content_feature
      else 
        return render_paragraph :text => ''
      end
    end
    render_paragraph :text => results.output
  end
end

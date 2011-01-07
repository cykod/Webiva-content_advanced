class ContentAdvanced::PageRenderer < ParagraphRenderer

  features '/content_advanced/page_feature'

  paragraph :stats

  def stats

    # Any instance variables will be sent in the data hash to the 
    # content_advanced_page_stats_feature automatically
  
    render_paragraph :feature => :content_advanced_page_stats
  end

end

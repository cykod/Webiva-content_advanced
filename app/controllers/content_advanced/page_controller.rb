class ContentAdvanced::PageController < ParagraphController

  editor_header 'Content Advanced Paragraphs'
  
  editor_for :stats, :name => "Stats", :feature => :content_advanced_page_stats

  class StatsOptions < HashModel

  end

end

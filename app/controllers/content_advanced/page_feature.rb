class ContentAdvanced::PageFeature < ParagraphFeature

  feature :content_advanced_page_stats, :default_feature => <<-FEATURE
    Stats Feature Code...
  FEATURE

  def content_advanced_page_stats_feature(data)
    webiva_feature(:content_advanced_page_stats,data) do |c|
      # c.define_tag ...
    end
  end

end

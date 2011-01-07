
class ContentAdvanced::PageFeature < ParagraphFeature

  feature :content_advanced_page_search_trends, :default_feature => <<-FEATURE
  <cms:keywords>
  <ul>
    <cms:keyword>
      <li><cms:search_link><cms:name/></cms:search_link></li>
    </cms:keyword>
  </ul>
  </cms:keywords>
  FEATURE

  def content_advanced_page_search_trends_feature(data)
    webiva_feature(:content_advanced_page_search_trends,data) do |c|
      c.loop_tag('keyword') { |t| data[:keywords] }
      c.h_tag('keyword:name') { |t| t.locals.keyword.keyword }
      c.link_tag('keyword:search') { |t| "#{data[:options].search_page_url}?q=#{CGI.escape t.locals.keyword.keyword}" }
    end
  end
end

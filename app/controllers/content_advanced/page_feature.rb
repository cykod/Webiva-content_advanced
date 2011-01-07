
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

  feature :content_advanced_page_most_viewed_content, :default_feature => <<-FEATURE
  Most Viewed
  <cms:most_viewed>
    <cms:contents>
    <ul>
    <cms:content>
      <li><cms:content_link><cms:title/></cms:content_link></li>
    </cms:content>
    </ul>
    </cms:contents>
  </cms:most_viewed>
  FEATURE

  def content_advanced_page_most_viewed_content_feature(data)
    webiva_feature(:content_advanced_page_most_viewed_content,data) do |c|
      c.expansion_tag('most_viewed') { |t| ! data[:most_viewed_contents].empty? }

      c.loop_tag('most_viewed:content') { |t| data[:most_viewed_contents] }
      c.h_tag("content:title") { |t| t.locals.content.title }
      c.link_tag("content:content") { |t| t.locals.content.link }
    end
  end
end

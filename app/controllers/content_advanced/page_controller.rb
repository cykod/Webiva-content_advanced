
class ContentAdvanced::PageController < ParagraphController

  editor_header 'Content Advanced Paragraphs'

  editor_for :search_trends, :name => "Search Trends", :feature => :content_advanced_page_search_trends

  editor_for :most_viewed_content, :name => "Most Viewed Content", :feature => :content_advanced_page_most_viewed_content

  class SearchTrendsOptions < HashModel
    attributes :search_page_id => nil, :days_ago => 30, :limit => 10

    page_options :search_page_id
    integer_options :days_ago, :limit

    validates_presence_of :search_page_id, :days_ago, :limit

    options_form(
                 fld(:search_page_id, :page_selector),
                 fld(:days_ago, :text_field, :unit => 'days'),
                 fld(:limit, :text_field)
                 )
  end

  class MostViewedContentOptions < HashModel
    attributes :days_ago => 30, :limit => 10

    integer_options :days_ago, :limit

    validates_presence_of :days_ago, :limit

    options_form(
                 fld(:days_ago, :text_field, :unit => 'days'),
                 fld(:limit, :text_field)
                 )
  end
end

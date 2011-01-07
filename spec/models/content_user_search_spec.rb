require  File.expand_path(File.dirname(__FILE__)) + "/../content_advanced_spec_helper"

describe ContentUserSearch do

  reset_domain_tables :content_search_keyword, :content_user_search, :domain_log_group, :domain_log_stat

  it "should require a keyword" do
    @user_search = ContentUserSearch.new
    @user_search.valid?

    @user_search.should have(1).error_on(:content_search_keyword_id)
  end

  describe "Stats" do
    before(:each) do
      @keyword1 = ContentSearchKeyword.create :keyword => 'test 1'
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 5.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 4.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 3.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 2.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 1.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword1.id, :created_at => 10.seconds.ago

      @keyword2 = ContentSearchKeyword.create :keyword => 'test 2'
      ContentUserSearch.create :content_search_keyword_id => @keyword2.id, :created_at => 5.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword2.id, :created_at => 4.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword2.id, :created_at => 1.days.ago
      ContentUserSearch.create :content_search_keyword_id => @keyword2.id, :created_at => 10.seconds.ago

      @keyword3 = ContentSearchKeyword.create :keyword => 'test 3'
      ContentUserSearch.create :content_search_keyword_id => @keyword3.id, :created_at => 1.days.ago
    end

    it "should be able to get search stats" do
      assert_difference 'DomainLogGroup.count', 1 do
        assert_difference 'DomainLogStat.count', 3 do
          @groups = ContentUserSearch.searches 1.week.ago, 1.week, 1
        end
      end

      @group = @groups[0]
      @stat = @group.domain_log_stats.find_by_target_id @keyword1.id
      @stat.hits.should == 6

      @stat = @group.domain_log_stats.find_by_target_id @keyword2.id
      @stat.hits.should == 4

      @stat = @group.domain_log_stats.find_by_target_id @keyword3.id
      @stat.hits.should == 1
    end
  end
end

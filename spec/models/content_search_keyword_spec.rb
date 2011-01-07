require  File.expand_path(File.dirname(__FILE__)) + "/../content_advanced_spec_helper"

describe ContentSearchKeyword do

  reset_domain_tables :content_search_keyword, :content_user_search, :domain_log_visitor, :end_user, :end_user_cache

  it "should require a keyword" do
    @keyword = ContentSearchKeyword.new
    @keyword.valid?

    @keyword.should have(1).error_on(:keyword)
  end

  it "should be able to create a keyword" do
    @keyword = ContentSearchKeyword.create(:keyword => "Fake Post")
    @keyword.id.should_not be_nil
    @keyword.keyword.should == 'Fake post'
  end

  describe "Users" do
    before(:each) do
      @user1 = EndUser.push_target 'test1@test.dev'
      @visitor1 = DomainLogVisitor.create(:ip_address => '127.0.0.1', :end_user_id => @user1.id)
      @user2 = EndUser.push_target 'test2@test.dev'
      @visitor2 = DomainLogVisitor.create(:ip_address => '127.0.0.1', :end_user_id => @user2.id)
    end

    it "should track a user's search" do
      search = "My Search"
      assert_difference 'ContentSearchKeyword.count', 1 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user1, @visitor1, search
        end
      end
      @search.domain_log_visitor_id.should be_nil
      @search.end_user_id.should == @user1.id

      assert_difference 'ContentSearchKeyword.count', 0 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should be_nil
      @search.end_user_id.should == @user2.id

      assert_difference 'ContentSearchKeyword.count', 0 do
        assert_difference 'ContentUserSearch.count', 0 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should be_nil
      @search.end_user_id.should == @user2.id

      search = "my other search"
      assert_difference 'ContentSearchKeyword.count', 1 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should be_nil
      @search.end_user_id.should == @user2.id
    end
  end

  describe "Visitors" do
    before(:each) do
      @user1 = EndUser.new
      @visitor1 = DomainLogVisitor.create(:ip_address => '127.0.0.1', :end_user_id => @user1.id)
      @user2 = EndUser.new
      @visitor2 = DomainLogVisitor.create(:ip_address => '127.0.0.1', :end_user_id => @user2.id)
    end

    it "should track a user's search" do
      search = "My Search"
      assert_difference 'ContentSearchKeyword.count', 1 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user1, @visitor1, search
        end
      end
      @search.domain_log_visitor_id.should == @visitor1.id
      @search.end_user_id.should be_nil

      assert_difference 'ContentSearchKeyword.count', 0 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should == @visitor2.id
      @search.end_user_id.should be_nil

      assert_difference 'ContentSearchKeyword.count', 0 do
        assert_difference 'ContentUserSearch.count', 0 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should == @visitor2.id
      @search.end_user_id.should be_nil

      search = "My Other search"
      assert_difference 'ContentSearchKeyword.count', 1 do
        assert_difference 'ContentUserSearch.count', 1 do
          @search = ContentSearchKeyword.push_search @user2, @visitor2, search
        end
      end
      @search.domain_log_visitor_id.should == @visitor2.id
      @search.end_user_id.should be_nil
    end
  end
end

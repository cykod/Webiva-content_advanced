
class ContentAdvanced::ManageController < ModuleController
  permit 'content_advanced_manage'

  component_info 'ContentAdvanced'

  cms_admin_paths 'content',
                  'Content'   => {:controller => '/content'},
                  'Searches'   => {:action => 'searches'}

  # need to include
  include ActiveTable::Controller
  active_table :searches_table,
                ContentSearchKeyword,
                [ :check,
                  :keyword,
                  :has_results,
                  :approved,
                  hdr(:static, :num_searches, :label => '# Searches'),
                  :created_at,
                  :updated_at
                ]

  def display_searches_table(display=true)
    active_table_action 'search' do |act,ids|
      case act
      when 'approve'
        ContentSearchKeyword.update_all 'approved = 1', ['id in(?)', ids]
      when 'disapprove'
        ContentSearchKeyword.update_all 'approved = 0', ['id in(?)', ids]
      end
    end

    @active_table_output = searches_table_generate params, :order => 'created_at'

    render :partial => 'searches_table' if display
  end

  def searches
    cms_page_path ['Content'], 'Searches'
    display_searches_table(false)
  end
end

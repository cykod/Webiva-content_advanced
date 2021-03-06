
class ContentAdvanced::AdminController < ModuleController

  component_info 'ContentAdvanced', :description => 'Content Advanced support', :access => :private, :dependencies => ['feedback', 'share', 'blog']

  # Register a handler feature
  register_permission_category :content_advanced, "ContentAdvanced" ,"Permissions related to Content Advanced"

  register_permissions :content_advanced, [[:manage, 'Manage Content Advanced', 'Manage Content Advanced'],
                                           [:config, 'Configure Content Advanced', 'Configure Content Advanced']
                                          ]

  content_model :content_advanced

  register_handler :webiva, :search_stats, 'ContentSearchKeyword'

  permit 'content_advanced_config'

  public
 
  def self.get_content_advanced_info
    [{:name => 'Searches', :url => {:controller => '/content_advanced/manage', :action => 'searches'}}]
  end
end

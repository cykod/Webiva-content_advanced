
class ContentAdvanced::AdminController < ModuleController

  component_info 'ContentAdvanced', :description => 'Content Advanced support', :access => :private

  # Register a handler feature
  register_permission_category :content_advanced, "ContentAdvanced" ,"Permissions related to Content Advanced"

  register_permissions :content_advanced, [[:manage, 'Manage Content Advanced', 'Manage Content Advanced'],
                                           [:config, 'Configure Content Advanced', 'Configure Content Advanced']
                                          ]

  permit 'content_advanced_config'

end

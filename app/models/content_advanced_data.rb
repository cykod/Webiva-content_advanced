

class ContentAdvancedData

  def self.most_viewed_content(args)

    from = args[:from]
    duration = args[:duration]
    limit = args[:limit] 

      groups = ContentNode.traffic from, duration, 1
      group = groups[0]
      target_ids = group.domain_log_stats.find(:all, :order => 'hits DESC', :limit => limit).collect(&:target_id)
      @most_viewed = ContentNodeValue.all :conditions => {:content_node_id => target_ids}

      groups = Comment.commented from, duration, 1
      group = groups[0]
      target_ids = group.domain_log_stats.find(:all,:order => 'hits DESC', :limit => limit).collect(&:target_id)
      @most_commented = ContentNodeValue.all :conditions => {:content_node_id => target_ids}

      groups = Share::EmailFriend.emailed from, duration, 1
      group = groups[0]
      target_ids = group.domain_log_stats.find(:all,:order => 'hits DESC', :limit => limit).collect(&:target_id)

      @most_shared = ContentNodeValue.all :conditions => {:content_node_id => target_ids}

      output =  { :most_viewed => @most_viewed, :most_commented => @most_commented, :most_shared =>  @most_shared  }
      DomainModel.remote_cache_put(args, output )

      return output

  end


end

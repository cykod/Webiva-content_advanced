class Searches < ActiveRecord::Migration
  def self.up
    create_table :content_search_keywords, :force => true do |t|
      t.string :keyword
      t.boolean :has_results, :default => true
      t.boolean :approved, :default => true
      t.timestamps
    end

    create_table :content_user_searches, :force => true do |t|
      t.integer :content_search_keyword_id
      t.integer :end_user_id
      t.integer :domain_log_visitor_id
      t.datetime :created_at
    end

    add_index :content_user_searches, [:created_at, :content_search_keyword_id], :name => 'content_user_searches_idx'
  end

  def self.down
    drop_table :content_search_keywords
    drop_table :content_user_searches
  end
end

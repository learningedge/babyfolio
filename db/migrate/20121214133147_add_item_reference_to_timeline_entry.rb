class AddItemReferenceToTimelineEntry < ActiveRecord::Migration
  def self.up
    change_table :timeline_entries do |t|
      t.references :item, :polymorphic => true
    end
  end

  def self.down
    change_table :timeline_entries do |t|
      t.remove_references :item, :polymorphic => true
    end
  end
end

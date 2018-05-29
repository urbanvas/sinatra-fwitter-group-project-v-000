class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :content
      t.string :user_id
    end
  end
end

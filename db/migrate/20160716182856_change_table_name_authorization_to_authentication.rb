class ChangeTableNameAuthorizationToAuthentication < ActiveRecord::Migration
  def self.up
    rename_table :authorizations, :authentications
  end
  def self.down
    rename_table :authentications, :authorizations
  end
end

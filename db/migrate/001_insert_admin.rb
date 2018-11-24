class InsertAdmin < Sequel::Migration

  def up
    self[:blog_users].insert(:username => 'admin', :password => 'camping')
  end

  def down
    self[:blog_users].delete(:username => 'admin')
  end
end

Sequel.migration do

  up do
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end

    create_table(:blog_users) do
      primary_key :id, type:Integer
      String :username
      String :password
      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:blog_posts) do
      primary_key :id, type:Integer
      Fixnum :user_id, :null=>false
      String :title, fixed:true
      Text :body
      Text :html_body
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:schema_info, :blog_users, :blog_posts)
  end

end

module App
  module Models
    class User < Sequel::Model(:blog_users); end
    class Post < Sequel::Model(:blog_posts)
      many_to_one :user
      def before_save
        cloth = RedCloth.new(self.body)
        cloth.hard_breaks = false
        self.html_body = cloth.to_html
        super
      end
    end
  end
end

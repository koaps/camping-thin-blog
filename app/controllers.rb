module App
  module Controllers
    class Index
      def get
        @posts = Post.order(Sequel.desc(:updated_at)).all
        render :index
      end
    end

    class PostNew
      def get
        require_login!
        @post = Post.new
        render :add
      end
      
      def post
        require_login!
        post = Post.create(:title => input.post_title, :body => input.post_body, :user_id => @state.user_id)
        redirect PostN, post.id
      end
    end

    class PostN
      def get(post_id) 
        @post = Post[post_id]
        render :view
      end
    end

    class Edit < R '/post/(\d+)/edit'
      def get(post_id)
        require_login!
        @post = Post[post_id]
        render :edit
      end

      def post(post_id)
        require_login!
        @post = Post[post_id]
        @post.raise_on_save_failure = false
        @post.update(:title => input.post_title, :body => input.post_body)
        redirect PostN, post_id
      end
    end

    class Login
      def get
        render :login
      end
      
      def post
        @user = User.where(:username => input.username, :password => input.password).first

        if @user
          @state.user_id = @user.id
          redirect R(Index)
        else
          @info = 'Wrong username or password.'
        end
        
        render :login
      end
    end

    class Logout
      def get
        @state.user_id = nil
        redirect Index
      end
    end

    class Style < R '/styles\.css'
      STYLE = File.read(File.join(APP_ROOT + '/app/styles.css'))

      def get
        @headers['Content-Type'] = 'text/css; charset=utf-8'
        STYLE
      end
    end
  end
end

module App
  module Views
    def layout
      html do
        head do
          title 'My Blog'
          link :rel => 'stylesheet', :type => 'text/css', 
          :href => '/styles.css', :media => 'screen'
        end
        body do
          h1 { a 'My Blog', :href => R(Index) }
          
          div.wrapper! do
            self << yield
          end
          
          hr
          
          p.footer! do
            if logged_in?
              _admin_menu
            else
              a 'Login', :href => R(Login)
              text ' to the adminpanel'
            end
            text! ' &ndash; Powered by '
            a 'Camping', :href => 'http://camping.rubyforge.org/'
          end
        end
      end
    end

    def index
      if @posts.empty?
        h2 'No posts'
        p do
          text 'Could not find any posts. Feel free to '
          a 'add one', :href => R(PostNew)
          text ' yourself. '
        end
      else
        @posts.each do |post|
          _post(post)
        end
      end
    end

    def login
      h2 'Login'
      p.info @info if @info
      
      form :action => R(Login), :method => 'post' do
        input :name => 'to', :type => 'hidden', :value => @to if @to
        
        label 'Username', :for => 'username'
        input :name => 'username', :id => 'username', :type => 'text'

        label 'Password', :for => 'password'
        input :name => 'password', :id => 'password', :type => 'password'

        input :type => 'submit', :class => 'submit', :value => 'Login'
      end
    end

    def add
      _form(@post, :action => R(PostNew))
    end

    def edit
      _form(@post, :action => R(Edit, @post.id))
    end

    def view
      _post(@post)
    end

    # partials
    def _admin_menu
      text! [['Log out', R(Logout)], ['New', R(PostNew)]].map { |name, to|
        mab { a name, :href => to}
      }.join(' &ndash; ')
    end

    def _post(post)
      h2 { a post.title, :href => R(PostN, post.id) }
      p.info do
        text! "Written by <strong>#{post.user.username}</strong> "
        text post.updated_at.strftime('%B %M, %Y @ %H:%M ')
        _post_menu(post)
      end
      text! post.html_body
    end
    
    def _post_menu(post)
      if logged_in?
        a '(edit)', :href => R(Edit, post.id)
      end
    end

    def _form(post, opts)
      form({:method => 'post'}.merge(opts)) do
        label 'Title', :for => 'post_title'
        input :name => 'post_title', :id => 'post_title', :type => 'text', 
              :value => post.title

        label 'Body', :for => 'post_body'
        textarea post.body, :name => 'post_body', :id => 'post_body'

        input :type => 'hidden', :name => 'post_id', :value => post.id
        input :type => 'submit', :class => 'submit', :value => 'Submit'
      end
    end
  end
end

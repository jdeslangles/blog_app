require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'
# require 'haml'

configure do
  enable :sessions
  # set :environment, "development"
end

before do
  if session["pageviews"].nil?
    session["pageviews"] = 0
  end
end


# Home page -  displays most recent posts and menu

get '/' do
  session["pageviews"] += 1
  puts session.inspect
  sql = "select * from blogposts order by published asc"
  @posts = run_sql(sql)
  erb :home
end


# Create new post

get '/new_post' do
  erb :new_post
end

post '/publish' do
  title = params[:title]
  author = params[:author]
  published = Time.now
  content = params[:content]
  sql = "insert into blogposts (title, author, published, content) values ('#{title}', '#{author}', '#{published}', '#{content}')"
  run_sql(sql)
  redirect to ('/')
end


#Display selected post in detail

get '/post/:id' do
  sql = "select * from blogposts where id = #{params[:id]}"
  @post = run_sql(sql).first
  erb :post
end


#Edit selected post

get '/edit/:id' do
  sql = "select * from blogposts where id = #{params[:id]}"
  @post = run_sql(sql).first
  erb :edit
end

post '/update/:id' do
  title = params[:title]
  author = params[:author]
  published = Time.now
  content = params[:content]
  sql = "update blogposts set title='#{title}', author='#{author}', published='#{published}', content='#{content}' where id=#{params[:id]}"
  run_sql(sql)
  redirect to("/post/#{params[:id]}")
end


#Delete selected post

get '/delete/:id' do
  sql = "delete from blogposts where id = #{params[:id]}"
  run_sql(sql)
  redirect to('/')
end


# Admin login/verif

get '/admin_login' do
  # unless session[:admin] == true
  #  redirect to('/')
  # end
  erb :admin_login
end

post '/admin_verif' do
  # if params['login'].to_s == "jcfdb" && params['password'].to_s == "password"
  #   session[:admin] = true
  #   redirect to('/admin')
  #end
end

# Method to access/close DB

def run_sql(sql)
  conn = PG.connect(:dbname =>'blogposts', :host => 'localhost')
  begin
    result = conn.exec(sql)
  ensure
    conn.close
  end
  result
end






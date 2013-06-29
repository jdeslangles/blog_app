require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'
require 'haml'

configure do
  enable :sessions
end

before do
  if session["pageviews"].nil?
    session["pageviews"] = 0
  end
end

get "/" do
  session["pageviews"] += 1
  puts session.inspect
  erb :index
end


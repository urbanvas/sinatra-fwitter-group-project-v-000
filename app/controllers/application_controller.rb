require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
    erb :'users/create_user'
  end

  end

  post '/signup' do
    if !(params[:username].empty? || params[:password].empty? || params[:email].empty?)
      user = User.create(params)
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/login' do

    if logged_in?
      redirect '/tweets'
    else

      erb :'users/login'
    end

  end

  post '/login' do

    user = User.find_by(:username => params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/"
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/tweets' do
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      erb :'tweets/tweets'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do

      if params[:content].empty?
        redirect '/tweets/new'
      else
        tweet = Tweet.new(params)
        tweet.user = current_user
        tweet.save
        redirect '/tweets'
      end

  end


  get '/tweets/:id/edit' do
    if logged_in?
    @tweet = Tweet.find(params[:id])
    erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    @tweet.update(:content => params[:content])
  end

  delete '/tweets/:id/delete' do
    Tweet.delete(params[:id])
    redirect 'users'
  end



  helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
      User.find(session[:user_id])
    end
  end



end

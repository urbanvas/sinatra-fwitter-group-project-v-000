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

      erb :index
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

  get '/tweets' do
    @user = current_user
    erb :'tweets/tweets'
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

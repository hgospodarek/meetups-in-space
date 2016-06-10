require 'sinatra'
require_relative 'config/application'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  erb :'meetups/index'
end

get '/meetups/:name' do
  #indiviual meet up details will appear here
  # => name of meet up
  # => description
  # => location
  # => creator
  # => users attending
  # => sign up button
end

post '/meetups/:name' do
  # => sign up button that wull take the user info and post it to the meetup details page
end


get '/meetups/create' do
  #Form where we can create a meetup with all the details below:
  # => name of meet up
  # => description
  # => location
  # => creator
end

post 'meetups/create' do
  # => name of meet up
  # => description
  # => location
  # => creator
  #rediect to the newly created meetup details page
  #if not created sucessfully an error shoudl appear and the fields that are filled should remains so.
end

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
  @meetups = Meetup.all.order(name: :asc)
  erb :'meetups/index'
end

post '/meetups' do
  if current_user.nil?
    flash[:notice] = "You cannot create a meetup without signing in."
    redirect "/meetups"
  else
    redirect "/meetups/new"
  end
end

get '/meetups/new' do
  erb :'meetups/new'
end

post '/meetups/new' do
  @name = params[:name]
  @location = params[:location]
  @description = params[:description]

  meetup = Meetup.new({name: @name, location: @location, description: @description})
  if !meetup.valid?
    @error = "Please fill out form completely."
    erb :'meetups/new'
  else
    meetup.save
    UserMeetup.create(user: current_user, meetup: meetup, creator: true)
    flash[:notice] = "Meetup created successfully!"
    redirect "/meetups/#{meetup.id}"
  end
end

get '/meetups/:id' do
  @signed_in_user = current_user
  @id = params[:id]
  @meetup = Meetup.find(@id)
  erb :'meetups/show'
end

post '/meetups/:id' do
  @id = params[:id]
  meetup = Meetup.find(@id)
  if current_user.nil?
    flash[:notice] = "You cannot join a meetup until you sign in."
    redirect "/meetups/#{@id}"
  else
    UserMeetup.create(user: current_user, meetup: meetup)
    flash[:notice] = "You joined this meetup!"
    redirect "/meetups/#{meetup.id}"
  end
end

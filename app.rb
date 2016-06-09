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
  if current_user.nil?
    @error = "Please sign in to create new meetup."
  end
  @meetups = Meetup.all.order(name: :asc)
  erb :'meetups/index'
end


get '/meetups/new' do
  erb :'meetups/new'
end

post '/meetups/new' do
  @signed_in_user = current_user

  @name = params[:name]
  @location = params[:location]
  @description = params[:description]

  meetup = Meetup.new({name: @name, location: @location, description: @description})
  if !meetup.valid?
    @error = "Please fill out form completely."
    erb :'meetups/new'
  else
    meetup.save
    UserMeetup.create(user: @signed_in_user, meetup: meetup, creator: true)
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
  # @joining_member = params[:joining_member]
  # @meetup = params[:meetup]
  # binding.pry
  # if @joining_member.empty?
  
  @id = params[:id]
  @meetup = Meetup.find(@id)
  if current_user.nil?
    flash[:notice] = "You cannot join a meetup until you sign in."
    redirect "/meetups/#{@id}"
  else
    UserMeetup.create(user: @joining_member, meetup: @meetup)
  end
end

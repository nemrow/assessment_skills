get '/' do
  # render home page
  @users = User.all
  @skills = Skill.all
  erb :index
end

#------------ ADD NEW SKILL -------------------

post '/new_skill' do
  skill = Skill.find_or_create_by_name(:name => params[:skill], :context => "creative") 
  new_skill = Proficiency.new(:user_id => current_user.id,
                              :skill_id => skill.id,
                              :years => params[:years],
                              :formal => params[:formal]
                              )
  new_skill.save
  redirect to '/'
end

get '/logout' do
  session[:user_id] = nil
end


#----------- SESSIONS -----------

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:user_id].to_i
  session.clear
  200
end


#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end

post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:user_id] = @user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end

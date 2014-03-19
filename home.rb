require 'sinatra'

get '/' do
  'Hello World!'
end

get '/about' do
  'a little about me'
end

get '/hello/:name' do
  
  "hello #{params[:name]}"
end

get '/hello/:name/:city' do
  "Hey there #{params[:name]} from #{params[:city]}."
end

get '/more/*' do
  "splat #{params[:splat]}"
end

get '/form' do
  erb :form # get the form.erb file from the views folder
end

post '/form' do
  "You said '#{params[:message]}'"
end

not_found do
  halt 404, 'page not found'
end
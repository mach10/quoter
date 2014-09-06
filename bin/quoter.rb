require 'sinatra'
require 'data_mapper'
require 'uri'
require_relative '../classes/quote'
require_relative '../classes/tweeter'
SITE_TITLE="Wit and Wisdom"
#part one http://code.tutsplus.com/tutorials/singing-with-sinatra--net-18965
#part two http://code.tutsplus.com/tutorials/singing-with-sinatra-the-recall-app--net-19128
#part threee http://code.tutsplus.com/tutorials/singing-with-sinatra-the-encore--net-19364

# sets root as the parent-directory of the current file
set :root, File.join(File.dirname(__FILE__), '..')
# sets the view directory correctly
set :views, Proc.new { File.join(root, 'views') }
set :server, 'webrick'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
#some comment
#sinatra default port = 4567 

 
DataMapper.finalize.auto_upgrade!
#to help stop XSS by converting all input into html entities
helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

#display all quotes. display form to add one quote
get '/quotes' do
  @quotes = Quote.all :order => :id.desc
  @title = 'All Quotes'
  erb :home
end

get '/quote' do
  content_type 'text/xml'
  @quotes = Quote.all :order => :id.desc
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+@quotes[1 + rand(@quotes.length)].to_xml
end

get '/tweet/:property' do
  content_type 'text/xml'
  prop1 = URI.decode params[:property]
  prop = prop1.gsub(/\s/,'')
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?><tweets>"+Tweeter.get_tweets(prop)+"</tweets>"
end

#add one new quote
post '/quote' do
  n = Quote.new
  n.content = params[:content]
  n.created_at = Time.now
  n.save
  redirect '/quote'
end

#get one qupte. display as editable / deletable
get '/:id' do
  @quote = Quote.get params[:id]
  @title = "Edit note ##{params[:id]}"
  erb :edit
end

#modify one quote
#note we've mocked the PUT request by including a hidden input field
#in our normal 'POST' form called _method with the value of 'put'. This automaticall
#allows us to use PUT here, and not POST.
put '/:id' do
  n = Quote.get params[:id]
  n.content = params[:content]
  n.save
  redirect '/quote'
end

#delete a single quote
get '/:id/delete' do
  @quote = Quote.get params[:id]
  @title = "Confirm deletion of Quote ##{params[:id]}"
  erb :delete
end

#note we are faking a DELETE method request in the same manner
#we faked a PUT method request above. 
delete '/:id' do
  q = Quote.get params[:id]
  q.destroy
  redirect '/quote'
end



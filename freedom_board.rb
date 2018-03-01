require 'sinatra'
require 'yaml/store'
require 'yaml'
require 'date'

def load_file
  if File.exist?("posts.yml")
    @posts = YAML.load(File.read("posts.yml"))
	@posts = Hash[@posts.to_a.reverse]
  end
end

get '/' do 
  load_file
  @posts = @posts.first(5)
  erb :index
end

get '/new_post' do
  erb :new_post
end 

get '/posts' do
  load_file 
  erb :posts
end

get '/about' do
  erb :about 
end

post '/' do
  @text = params['message']
  @user = params['name']
  @time = (DateTime.now).strftime "%m/%d/%Y %H:%M:%S"
  
  if @user == '' then @user = 'Anonymous' end
  
  #Post = Struct.new :user, :text, :time
  #post = Post.new(@user, @text, @time)
  @store = YAML::Store.new "posts.yml"
  
  @store.transaction do
	@store[@time] = [@user, @text]
  end
  
  load_file
  @posts = (Hash[@posts.to_a.reverse]).first(5)
  erb :index 
end

post '/search' do
  load_file
  @keyword = params['search-term']
  @posts = @posts.select{|time, value| value[1] =~ Regexp.new(@keyword, Regexp::IGNORECASE) || value[0] =~ Regexp.new(@keyword, Regexp::IGNORECASE)}
  erb :posts
end 

	



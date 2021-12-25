CORSLIST = '*'
PORT = 8888
BIND = '0.0.0.0'
#------------------------------------------
require 'sinatra'
require "sinatra/cross_origin"


set :port, PORT
set :bind, BIND
set :public_folder, 'public'

class V
   def initialize
       @id = 0
       @mt = Mutex.new        
   end

   def getid
       @mt.lock
       a = @id 
       @id += 1
       @mt.unlock
       a
   end
end

VV = V.new

configure do
    enable :cross_origin
end


before do
    response.headers['Access-Control-Allow-Origin'] = CORSLIST
end


post '/' do
begin    
    k = VV.getid
    File.write "tmp#{k}", request.body.read
    `ruby runner.rb tmp#{k}`
ensure
    File.delete "tmp#{k}"
end
end

options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = CORSLIST
    200
end

get '/' do
    redirect '/index.html'
end

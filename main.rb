require 'sinatra'
require "sinatra/cross_origin"

set :port, 8888
set :bind, '0.0.0.0'
set :cors_list, '*'
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
    response.headers['Access-Control-Allow-Origin'] = '*'
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
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
end